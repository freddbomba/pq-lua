-- Main Love2D script

-- Declare variables for images, shader, and canvas
local background_image
local mask_image
local shader
local canvas -- To store the masked parts

-- Variables to move the mask image
local mask_x, mask_y = 0, 0
local mask_speed = 200 -- Base speed for the mask
local mask_dx, mask_dy = 0, 0 -- Directional velocity for the mask

-- Alpha control
local alpha_time = 0 -- To track the alpha oscillation
local alpha_min = 0.3
local alpha_max = 0.9
local alpha_duration = 3 -- Duration for alpha oscillation in seconds

-- Screen dimensions
local screen_width, screen_height

function love.load()
    -- Load images
    background_image = love.graphics.newImage("1.png")
    mask_image = love.graphics.newImage("brush.png")

    -- Check if images are loaded
    if not background_image or not mask_image then
        error("One or more images failed to load.")
    end

    -- Load the shader
    shader = love.graphics.newShader("mask.glsl")

    -- Send the mask image to the shader
    shader:send("mask", mask_image)

    -- Get screen dimensions
    screen_width = love.graphics.getWidth()
    screen_height = love.graphics.getHeight()

    -- Create a canvas to store the masked image
    canvas = love.graphics.newCanvas(screen_width, screen_height)

    -- Initialize mask position to the center of the screen
    mask_x = screen_width / 2
    mask_y = screen_height / 2

    -- Random initial velocity
    mask_dx = love.math.random(-mask_speed, mask_speed)
    mask_dy = love.math.random(-mask_speed, mask_speed)
end

function love.update(dt)
    -- Update mask position based on its velocity
    mask_x = mask_x + mask_dx * dt
    mask_y = mask_y + mask_dy * dt

    -- Bounce the mask off the screen edges
    if mask_x < 0 then
        mask_x = 0
        mask_dx = -mask_dx
    elseif mask_x + mask_image:getWidth() > screen_width then
        mask_x = screen_width - mask_image:getWidth()
        mask_dx = -mask_dx
    end

    if mask_y < 0 then
        mask_y = 0
        mask_dy = -mask_dy
    elseif mask_y + mask_image:getHeight() > screen_height then
        mask_y = screen_height - mask_image:getHeight()
        mask_dy = -mask_dy
    end

    -- Update the alpha value to oscillate between alpha_min and alpha_max
    alpha_time = (alpha_time + dt) % alpha_duration
    local alpha_range = alpha_max - alpha_min
    local alpha_value = alpha_min + alpha_range * 0.5 * (1 + math.sin((alpha_time / alpha_duration) * 2 * math.pi))

    -- Paint the current masked area to the canvas
    love.graphics.setCanvas(canvas)
    love.graphics.clear() -- Clear the canvas before drawing
    love.graphics.setShader(shader)
    shader:send("mask_position", {mask_x, mask_y})
    shader:send("mask_alpha", alpha_value)
    love.graphics.draw(background_image, 0, 0) -- Draw the current image into the canvas using the shader
    love.graphics.setShader()
    love.graphics.setCanvas()
end

function love.draw()
    -- Draw the already painted areas from the canvas
    love.graphics.draw(canvas, 0, 0)

    -- Optionally draw the brush as a visual representation of the moving mask (optional)
    -- love.graphics.draw(mask_image, mask_x, mask_y)
end

-- Optional: Allow random velocity changes on keypress (press 'r')
function love.keypressed(key)
    if key == "r" then
        mask_dx = love.math.random(-mask_speed, mask_speed)
        mask_dy = love.math.random(-mask_speed, mask_speed)
    end
end
