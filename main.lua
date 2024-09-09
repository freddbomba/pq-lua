-- Henon Map using Love2D
-- Wind strength vector is used to adjust parameters a and b of the Henon map

-- Function to generate a Henon map point
function henon_map(x, y, a, b)
    local new_x = 1 - a * x^2 + y
    local new_y = b * x
    return new_x, new_y
end

-- Function to adjust Henon map parameters based on wind vector
function adjust_parameters_from_wind(wind_vector)
    -- Assuming wind_vector is a table {wind_x, wind_y} representing direction and magnitude
    local wind_magnitude = math.sqrt(wind_vector[1]^2 + wind_vector[2]^2)
    
    -- Normalize wind strength to some reasonable range for Henon parameters
    local max_wind_strength = 100  -- This is arbitrary, adjust as needed
    local norm_wind_strength = math.min(wind_magnitude / max_wind_strength, 1)

    -- Use normalized wind strength to adjust a and b
    local a = 1.4 + 0.1 * norm_wind_strength -- a in range [1.4, 2.0]
    local b = 0.3 + 0.02 * norm_wind_strength -- b in range [0.3, 0.5]

    return a, b
end

-- Function to generate Henon map points
function generate_henon_points(num_points, wind_vector)
    -- Initialize Henon map starting point
    local x, y = 0.1, 0.1

    -- Get parameters from wind strength
    local a, b = adjust_parameters_from_wind(wind_vector)

    -- Generate Henon map points
    local points = {}
    for i = 1, num_points do
        x, y = henon_map(x, y, a, b)
        table.insert(points, {x, y})
    end
    return points
end

-- Love2D function to load the game
function love.load()
    -- Example wind vector (direction and strength in knots)
    wind_vector = {0, 0} -- Adjust this for different wind conditions
    num_points = 10000     -- Number of Henon map points to generate

    -- Generate Henon map points
    points = generate_henon_points(num_points, wind_vector)

    -- Set background color to black
    love.graphics.setBackgroundColor(0, 0, 0)
end

-- Love2D function to draw on the screen
function love.draw()
    -- Set point color to white
    love.graphics.setColor(1, 1, 1)

    -- Center the Henon map points in the middle of the screen
    local screen_width = love.graphics.getWidth()
    local screen_height = love.graphics.getHeight()

    -- Scale and translate points to fit within the window
    local scale = 200
    local offset_x = screen_width / 2
    local offset_y = screen_height / 2

    -- Draw all points from the Henon map
    for i, point in ipairs(points) do
        local x = point[1] * scale + offset_x
        local y = point[2] * scale + offset_y
        love.graphics.points(x, y)
    end
end
