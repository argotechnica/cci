-- by @scholtz & @tyleretters

local sampler = {}

function sampler:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function sampler:set_sample_volume(fname, db)
  engine.sample_set(fname, "db", db)
end

function sampler:play_loop(fname)
  local fade = 0.005
  engine.sample_play(fname, fade, 1)
end

function sampler:stop_loop(fname)
  local fade = 0.005
  engine.sample_stop(fname, fade)
end

function sampler:linear_fade_out(fname, fade)
  engine.sample_stop(fname, fade)
end

function sampler:linear_fade_in(fname, fade)
  engine.sample_play(fname, fade, 1)
end

function sampler:play_oneshot(fname)
  local fade = 0.005
  engine.sample_play(fname, fade, 0)
end

function sampler:test()
  clock.run(function()
    fname="/home/we/dust/audio/tehn/drumev.wav"
    clock.sleep(1)
    self:set_sample_volume(fname, -24)
    clock.sleep(1)
    self:play_loop(fname)
    clock.sleep(1)
    self:set_sample_volume(fname, -12)
    clock.sleep(1)
    self:set_sample_volume(fname ,-3)
    clock.sleep(3)
    self:stop_loop(fname)
    clock.sleep(3)
    self:linear_fade_in(fname, 3)
    clock.sleep(3)
    self:linear_fade_out(fname, 1)
    clock.sleep(2)
    self:play_oneshot(fname)
  end)
end

return sampler