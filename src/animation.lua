local class = {}

function class.new(sprite, frames, framerate, frameX, frameY, frameWidth, frameHeight)
  local animation = {}

  animation.sprite       = sprite
  animation.frames       = frames
  animation.framerate    = framerate
  animation.frameX       = frameX
  animation.frameY       = frameY
  animation.frameWidth   = frameWidth
  animation.frameHeight  = frameHeight
  animation.currentFrame = 1
  animation.timer        = 0

  -- Création des quads de l'animation
  animation.quads = {}
  for frame = 1, frames do
    animation.quads[frame] = love.graphics.newQuad(frameX + (frame-1) * frameWidth, frameY, frameWidth, frameHeight, sprite:getDimensions())
  end

  return animation
end

function class.update(animation, dt)
  animation.timer = animation.timer + dt
  if (animation.timer > 1/animation.framerate) then
    animation.timer = animation.timer - 1/animation.framerate
    animation.currentFrame = animation.currentFrame + 1
    if (animation.currentFrame > animation.frames) then
      animation.currentFrame = 1
    end
  end
end

function class.draw(animation, x, y, frameWidth, frameHeight)
  love.graphics.draw(animation.sprite, animation.quads[animation.currentFrame], x, y, 0, 1, 1, frameWidth/2, frameHeight/2)
end

return class
