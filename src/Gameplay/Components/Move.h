#pragma once
#include "IComponent.h"
#include "Gameplay/Physics/RigidBody.h"

/// <summary>
/// A simple behaviour that applies an impulse along the Z axis to the 
/// rigidbody of the parent when the space key is pressed
/// </summary>
class Move : public Gameplay::IComponent {
public:
	typedef std::shared_ptr<Move> Sptr;

	std::weak_ptr<Gameplay::IComponent> Panel;

	Move();
	virtual ~Move();

	virtual void Awake() override;
	virtual void Update(float deltaTime) override;

public:
	virtual void RenderImGui() override;
	MAKE_TYPENAME(Move);
	virtual nlohmann::json ToJson() const override;
	static Move::Sptr FromJson(const nlohmann::json& blob);

	float radius = 1;

protected:
	
	float timer = 0.0f;
	glm::vec3 startPos;

};