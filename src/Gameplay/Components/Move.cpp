#include "Gameplay/Components/Move.h"
#include <GLFW/glfw3.h>
#include "Gameplay/GameObject.h"
#include "Gameplay/Scene.h"
#include "Utils/ImGuiHelper.h"
#include "Gameplay/InputEngine.h"

void Move::Awake()
{
	startPos = GetGameObject()->GetPosition();
}

void Move::RenderImGui() {
	LABEL_LEFT(ImGui::DragFloat, "Radius", &radius, 1.0f);
}

nlohmann::json Move::ToJson() const {
	return {
		{ "impulse", radius }
	};
}

Move::Move() :
	IComponent(),
	radius(1.0f)
{ }

Move::~Move() = default;

Move::Sptr Move::FromJson(const nlohmann::json& blob) {
	Move::Sptr result = std::make_shared<Move>();
	result->radius = blob["radius"];
	return result;
}

void Move::Update(float deltaTime) {
	timer += deltaTime;
	GetGameObject()->SetPostion(startPos.x + glm::vec3(cos(timer) * radius, startPos.y + sin(timer) * radius, startPos.z));

}

