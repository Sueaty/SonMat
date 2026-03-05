//
//  MockData.swift
//  SonMat
//

import Foundation

extension Recipe {
    static let mock: [Recipe] = [
        Recipe(
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            title: "된장찌개",
            description: "구수하고 깊은 맛의 전통 된장찌개입니다. 두부와 애호박을 넣어 든든하게 즐길 수 있어요.",
            imageURL: nil,
            thumbnailURL: nil,
            category: "찌개",
            prepTime: 10,
            cookTime: 20,
            servings: 2,
            ingredients: [
                "된장 2큰술",
                "두부 1/2모",
                "애호박 1/2개",
                "양파 1/2개",
                "대파 1/2대",
                "청양고추 1개",
                "멸치다시마육수 2컵",
                "국간장 1작은술",
                "다진 마늘 1작은술"
            ],
            createdAt: Date(timeIntervalSince1970: 1_700_000_000),
            updatedAt: Date(timeIntervalSince1970: 1_700_000_000)
        ),
        Recipe(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
            title: "김치볶음밥",
            description: "잘 익은 묵은지로 만든 고소하고 매콤한 김치볶음밥입니다. 계란 후라이를 올려 완성하세요.",
            imageURL: nil,
            thumbnailURL: nil,
            category: "볶음밥",
            prepTime: 5,
            cookTime: 10,
            servings: 1,
            ingredients: [
                "묵은지 1컵",
                "밥 1공기",
                "삼겹살 80g",
                "참기름 1큰술",
                "간장 1작은술",
                "설탕 1/2작은술",
                "계란 1개",
                "김 약간",
                "참깨 약간"
            ],
            createdAt: Date(timeIntervalSince1970: 1_700_100_000),
            updatedAt: Date(timeIntervalSince1970: 1_700_100_000)
        ),
        Recipe(
            id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
            title: "잡채",
            description: "쫄깃한 당면과 알록달록한 채소가 어우러진 명절 대표 요리입니다.",
            imageURL: nil,
            thumbnailURL: nil,
            category: "반찬",
            prepTime: 20,
            cookTime: 15,
            servings: 4,
            ingredients: [
                "당면 200g",
                "소고기 100g",
                "시금치 100g",
                "당근 1/2개",
                "양파 1/2개",
                "표고버섯 3개",
                "간장 3큰술",
                "설탕 1큰술",
                "참기름 1큰술",
                "다진 마늘 1작은술",
                "참깨 약간",
                "식용유 적당량"
            ],
            createdAt: Date(timeIntervalSince1970: 1_700_200_000),
            updatedAt: Date(timeIntervalSince1970: 1_700_200_000)
        )
    ]
}

extension Step {
    static let mock: [Step] = [
        // 된장찌개
        Step(id: UUID(), recipeID: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!, stepNumber: 1, imageURL: nil, instruction: "냄비에 멸치다시마육수를 붓고 끓입니다."),
        Step(id: UUID(), recipeID: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!, stepNumber: 2, imageURL: nil, instruction: "육수가 끓으면 된장을 풀어 넣고 양파를 넣습니다."),
        Step(id: UUID(), recipeID: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!, stepNumber: 3, imageURL: nil, instruction: "두부와 애호박을 한 입 크기로 잘라 넣습니다."),
        Step(id: UUID(), recipeID: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!, stepNumber: 4, imageURL: nil, instruction: "다진 마늘, 청양고추, 대파를 넣고 5분 더 끓입니다. 국간장으로 간을 맞춥니다."),

        // 김치볶음밥
        Step(id: UUID(), recipeID: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!, stepNumber: 1, imageURL: nil, instruction: "묵은지는 속을 털어내고 잘게 썰어 준비합니다."),
        Step(id: UUID(), recipeID: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!, stepNumber: 2, imageURL: nil, instruction: "팬에 삼겹살을 볶다가 김치를 넣고 함께 볶습니다."),
        Step(id: UUID(), recipeID: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!, stepNumber: 3, imageURL: nil, instruction: "밥을 넣고 간장, 설탕을 넣어 고루 볶습니다."),
        Step(id: UUID(), recipeID: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!, stepNumber: 4, imageURL: nil, instruction: "참기름을 두르고 접시에 담은 뒤 계란 후라이와 김 가루를 얹어 완성합니다."),

        // 잡채
        Step(id: UUID(), recipeID: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!, stepNumber: 1, imageURL: nil, instruction: "당면은 찬물에 30분 불린 뒤 끓는 물에 6분 삶아 건집니다."),
        Step(id: UUID(), recipeID: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!, stepNumber: 2, imageURL: nil, instruction: "소고기는 간장, 설탕, 참기름, 마늘로 밑간하여 볶습니다."),
        Step(id: UUID(), recipeID: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!, stepNumber: 3, imageURL: nil, instruction: "채소를 각각 볶아 준비합니다."),
        Step(id: UUID(), recipeID: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!, stepNumber: 4, imageURL: nil, instruction: "삶은 당면에 간장, 설탕, 참기름으로 양념하고 모든 재료를 넣어 버무립니다. 참깨를 뿌려 완성합니다.")
    ]
}
