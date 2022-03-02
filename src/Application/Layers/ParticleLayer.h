#pragma once
#include "../ApplicationLayer.h"


class ParticleLayer : public ApplicationLayer {
public:
	MAKE_PTRS(ParticleLayer);
	ParticleLayer();
	virtual ~ParticleLayer();

	void OnUpdate() override;
	void OnRender(const Framebuffer::Sptr& prevLayer) override;

};