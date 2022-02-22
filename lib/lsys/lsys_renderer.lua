-- by @jaseknighter

local lsys_renderer = {}

lsys_renderer.redo_render = 0
lsys_renderer.top_edge = 5
lsys_renderer.right_edge = 40
lsys_renderer.bottom_edge = 80
lsys_renderer.left_edge = 5 



function lsys_renderer.set_edges(t, r, b, l)
  lsys_renderer.top_edge = t
  lsys_renderer.right_edge = r
  lsys_renderer.bottom_edge = b
  lsys_renderer.left_edge = l
end

function lsys_renderer.check_lsys_position()
  lsys_renderer.redo = false
  lsys_renderer.redo_render = lsys_renderer.redo_render + 1
  if lsys_renderer.redo_render > 3 then 
    return 
  end

  local leftmost_point, rightmost_point, topmost_point, bottommost_point
  local turtle_positions = lsys_controller.get_turtle_positions()
  for j=1, #turtle_positions,1 do
    if (leftmost_point == nil) then
      leftmost_point = turtle_positions[j].x
      rightmost_point = turtle_positions[j].x
      topmost_point = turtle_positions[j].y
      bottommost_point = turtle_positions[j].y
    end

    if (turtle_positions[j].x) then
      if (turtle_positions[j].x < leftmost_point) then
        leftmost_point = turtle_positions[j].x
      end
      if (turtle_positions[j].x > rightmost_point) then
        rightmost_point = turtle_positions[j].x
      end
      if (turtle_positions[j].y < topmost_point) then
        topmost_point = turtle_positions[j].y
      end
      if (turtle_positions[j].y > bottommost_point) then
        bottommost_point = turtle_positions[j].y
      end
    end
  end
    
  if (leftmost_point) then
    local plant_width = rightmost_point - leftmost_point
    local plant_height = bottommost_point - topmost_point
    -- print(plant_width, plant_height)
    if plant_width > lsys_renderer.right_edge or plant_height > lsys_renderer.bottom_edge then
      lsys_renderer.redo = true
      lsys_controller.set_node_length(0.9)
      clock.run(lsys_renderer.recheck_lsys_position)
    end
    if (plant_width < lsys_renderer.right_edge - 5 and plant_height < lsys_renderer.bottom_edge - 5) then
      lsys_renderer.redo = true
      lsys_controller.set_node_length(1.1)
      clock.run(lsys_renderer.recheck_lsys_position)
    end
    if (leftmost_point < lsys_renderer.left_edge) then
      lsys_renderer.redo = true
      lsys_controller.set_offset(1, 0)
      clock.run(lsys_renderer.recheck_lsys_position)
    end 
    
    if topmost_point < lsys_renderer.top_edge  then
      lsys_renderer.redo = true
      lsys_controller.set_offset(0, 1)
      clock.run(lsys_renderer.recheck_lsys_position)
    end
    
    if rightmost_point > lsys_renderer.right_edge then
      lsys_renderer.redo = true
      lsys_controller.set_offset(-1, 0)
      clock.run(lsys_renderer.recheck_lsys_position)
    end
    if bottommost_point > lsys_renderer.bottom_edge then
      lsys_renderer.redo = true
      lsys_controller.set_offset(0, -1)
      clock.run(lsys_renderer.recheck_lsys_position)
    end
  end
end


lsys_renderer.recheck_lsys_position = function()
  screen.clear()
  clock.sync(1/15)
  -- print("recheck")
  lsys_renderer.check_lsys_position()
  -- lsys_controller.redraw()
  
end

lsys_renderer.draw_lsys = function()
  lsys_renderer.redo_render = 0
  lsys_renderer.check_lsys_position() 
  lsys_controller.redraw()
  if lsys_renderer.redo == false then
  end

  -- lsys_renderer.draw_lsys()
end

return lsys_renderer
