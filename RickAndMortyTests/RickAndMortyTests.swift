//
//  RickAndMortyTests.swift
//  RickAndMortyTests
//
//  Created by Sergio Garcia Vargas on 02/06/26.
//

import Testing
@testable import RickAndMorty

@MainActor
struct RickAndMortyTests {

    @Test func fetchCharactersUpdatesCharactersList() async {
        let charactersModel = CharactersModel(
            info: Info(count: 1, pages: 1, next: nil, prev: nil),
            results: [.mock(id: 1, name: "Rick Sanchez")]
        )
        let service = MockCharactersService(charactersModel: charactersModel)
        let viewModel = makeViewModel(service: service)

        await viewModel.fetchCharacters(for: 1)

        #expect(service.requestedPage == 1)
        #expect(viewModel.charactersList?.info.count == 1)
        #expect(viewModel.charactersList?.results == charactersModel.results)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == nil)
    }

    @Test func fetchSingleCharacterUpdatesCharacter() async {
        let expectedCharacter = Character.mock(id: 2, name: "Morty Smith")
        let service = MockCharactersService(singleCharacter: expectedCharacter)
        let viewModel = makeViewModel(service: service)

        await viewModel.fetchSingleCharacter(withId: 2)

        #expect(service.requestedCharacterId == 2)
        #expect(viewModel.character == expectedCharacter)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error == nil)
    }

    @Test func fetchMultipleCharactersUpdatesCharacters() async {
        let expectedCharacters = [
            Character.mock(id: 1, name: "Rick Sanchez"),
            Character.mock(id: 2, name: "Morty Smith")
        ]
        let service = MockCharactersService(multipleCharacters: expectedCharacters)
        let viewModel = makeViewModel(service: service)

        await viewModel.fetchMultipleCharacters(withIds: "1,2")

        #expect(service.requestedMultipleIds == "1,2")
        #expect(viewModel.characters == expectedCharacters)
        #expect(viewModel.error == nil)
        #expect(viewModel.isLoading == false)
    }

    @Test func fetchCharactersStoresErrorWhenServiceFails() async {
        let service = MockCharactersService(error: TestError.serviceFailure)
        let viewModel = makeViewModel(service: service)

        await viewModel.fetchCharacters(for: 1)

        #expect(viewModel.charactersList == nil)
        #expect(viewModel.error != nil)
        #expect(viewModel.isLoading == false)
    }

    @Test func saveStickersDelegatesToRepository() {
        let repository = MockStickerRepository()
        let viewModel = makeViewModel(stickerRepository: repository)
        let stickers = [Character.mock(id: 3, name: "Summer Smith")]

        viewModel.saveStickers(from: stickers)

        #expect(repository.savedCharacters == stickers)
        #expect(viewModel.isLoading == false)
    }

    @Test func fetchAllStickersDelegatesToRepository() {
        let repository = MockStickerRepository()
        let viewModel = makeViewModel(stickerRepository: repository)

        let stickers = viewModel.fetchAllStickers()

        #expect(stickers.isEmpty)
        #expect(repository.didFetchAllStickers)
        #expect(viewModel.isLoading == false)
    }

    @Test func buyPackShowsPointsErrorWhenPaymentFails() async {
        let service = MockCharactersService()
        let repository = MockStickerRepository()
        let pointsManager = MockPointsManager(canSpendPoints: false)
        let viewModel = makeViewModel(
            service: service,
            stickerRepository: repository,
            pointsManager: pointsManager
        )

        await viewModel.buyPack(quantity: 3, cost: 100)

        #expect(pointsManager.spentAmount == 100)
        #expect(viewModel.pointsError)
        #expect(viewModel.showPackResult == false)
        #expect(repository.savedCharacters.isEmpty)
        #expect(service.requestedMultipleIds == nil)
        #expect(viewModel.isLoading == false)
    }

    @Test func buyPackFetchesAndSavesStickersWhenPaymentSucceeds() async {
        let expectedCharacters = [
            Character.mock(id: 4, name: "Beth Smith"),
            Character.mock(id: 5, name: "Jerry Smith")
        ]
        let service = MockCharactersService(multipleCharacters: expectedCharacters)
        let repository = MockStickerRepository()
        let pointsManager = MockPointsManager(canSpendPoints: true)
        let viewModel = makeViewModel(
            service: service,
            stickerRepository: repository,
            pointsManager: pointsManager
        )
        UserDefaultsManager.shared.save(826, forKey: .albumLength)
        defer { UserDefaultsManager.shared.remove(forKey: .albumLength) }

        await viewModel.buyPack(quantity: 2, cost: 50)

        #expect(pointsManager.spentAmount == 50)
        #expect(service.requestedMultipleIds != nil)
        #expect(viewModel.characters == expectedCharacters)
        #expect(repository.savedCharacters == expectedCharacters)
        #expect(viewModel.lastPackStickers == expectedCharacters)
        #expect(viewModel.showPackResult)
        #expect(viewModel.pointsError == false)
        #expect(viewModel.isLoading == false)
    }

    private func makeViewModel(
        service: CharactersServiceProtocol = MockCharactersService(),
        stickerRepository: StickerRepositoryProtocol = MockStickerRepository(),
        pointsManager: PointsManagerProtocol = MockPointsManager()
    ) -> CharactersViewModel {
        CharactersViewModel(
            service: service,
            stickerRepository: stickerRepository,
            pointsManager: pointsManager
        )
    }
}

private final class MockCharactersService: CharactersServiceProtocol {
    var charactersModel: CharactersModel
    var singleCharacter: Character
    var multipleCharacters: [Character]
    var error: Error?
    var requestedPage: Int?
    var requestedCharacterId: Int?
    var requestedMultipleIds: String?

    init(
        charactersModel: CharactersModel = CharactersModel(
            info: Info(count: 0, pages: 0, next: nil, prev: nil),
            results: []
        ),
        singleCharacter: Character = .mock(),
        multipleCharacters: [Character] = [],
        error: Error? = nil
    ) {
        self.charactersModel = charactersModel
        self.singleCharacter = singleCharacter
        self.multipleCharacters = multipleCharacters
        self.error = error
    }

    func fetchCharacters(for page: Int) async throws -> CharactersModel {
        requestedPage = page
        if let error { throw error }
        return charactersModel
    }

    func fetchSingleCharacter(withId id: Int) async throws -> Character {
        requestedCharacterId = id
        if let error { throw error }
        return singleCharacter
    }

    func fetchMultipleCharacters(withIds ids: String) async throws -> [Character] {
        requestedMultipleIds = ids
        if let error { throw error }
        return multipleCharacters
    }
}

private final class MockStickerRepository: StickerRepositoryProtocol {
    var savedCharacters: [Character] = []
    var didFetchAllStickers = false

    func saveStickers(from characters: [Character]) {
        savedCharacters = characters
    }

    func fetchSticker(id: Int) -> StickerEntity? {
        nil
    }

    func fetchAllStickers() -> [StickerEntity] {
        didFetchAllStickers = true
        return []
    }

    func removeOneDuplicate(stickerId: Int) {}

    func receiveSticker(_ sticker: TradeStickerPayload) {}
}

private final class MockPointsManager: PointsManagerProtocol {
    var points: Int
    var canSpendPoints: Bool
    var spentAmount: Int?

    init(points: Int = 0, canSpendPoints: Bool = true) {
        self.points = points
        self.canSpendPoints = canSpendPoints
    }

    func getPoints() -> Int {
        points
    }

    func addPoints(_ amount: Int) {
        points += amount
    }

    func spendPoints(_ amount: Int) -> Bool {
        spentAmount = amount
        return canSpendPoints
    }
}

private enum TestError: Error {
    case serviceFailure
}

private extension Character {
    static func mock(id: Int = 1, name: String = "Rick Sanchez") -> Character {
        Character(
            id: id,
            name: name,
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Origin(name: "Earth", url: "https://rickandmortyapi.com/api/location/1"),
            location: Location(name: "Earth", url: "https://rickandmortyapi.com/api/location/20"),
            image: "https://rickandmortyapi.com/api/character/avatar/\(id).jpeg",
            episode: ["https://rickandmortyapi.com/api/episode/1"],
            url: "https://rickandmortyapi.com/api/character/\(id)",
            created: "2017-11-04T18:48:46.250Z"
        )
    }
}
