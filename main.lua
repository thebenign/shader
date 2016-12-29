hsl = require("HSL")

function love.load()
    -- load the noise glsl as a string
    local perlin = love.filesystem.read("noise2D.glsl")
 
    -- prepend the noise function definition to the effect definition
    noise = love.graphics.newShader(perlin .. [[
        extern number shiftx = 3;
        extern number shifty = 3;
        extern number freq = 4;
        extern number falloff = 1;
        extern number seed = 0;
        extern number oct = 7;
        
        vec4 effect(vec4 colour, Image image, vec2 local, vec2 screen)
        {
            number nx = (screen.x/1200.0 - .5)*freq+(shiftx+seed);
            number ny = (screen.y/1200.0 - .5)*freq+(shifty+seed);
            number noise = 0;
            number divisor = 0;
            number div_total = 0;
            vec4 pixel = Texel(image, local);
            for (int i = 0; i <= oct; i++)
            {
                divisor = pow(2.0 ,float(i));
                noise += .5*(.5+snoise(vec2(divisor*nx,divisor*ny)))/divisor;
                div_total += (1/divisor);
            }
            
            // the noise is between -1 and 1, so scale it between 0 and 1
            
            //noise = noise * 0.5 + 0.5;
            
            noise /= div_total;
            noise = pow(max(noise,0),float(falloff));
            return (vec4(1,1,1,noise));
        }
    ]])
    shiftx,shifty = 3, 3
    seed = math.random()*200
    freq = 4
    falloff = 1
    color = {math.random(255),math.random(255),math.random(255)}
    h = 0
    speed = .1
    offset = 0
    stars = genStars(love.graphics.getWidth(),love.graphics.getHeight(),.025,.15)
end

 function genStars(w, h, dense, bright)
    local count = math.floor(w * h * dense)
    local points = {}
    local r, c
    for i = 0, count do
        r = math.ceil(math.random() * w * h)
        c = math.floor(255 * math.log(1-math.random())* -bright)
        points[i] = {r%w, math.floor(r/w), c, c, c, 255}
    end
    return points
end

function love.update(dt)
    offset = offset + .01
    --noise:send("offset",{0,offset})
    if love.keyboard.isDown("kp0") then
        h = h + 1%255
        love.graphics.setColor(hsl(h,255,200))
    end
    
    if love.keyboard.isDown("space") then
        seed = math.random()*200
        noise:send("seed", seed)
    end
    
    if love.keyboard.isDown("up") then
        shifty = shifty - speed
        noise:send("shifty", shifty)
    end
    if love.keyboard.isDown("down") then
        shifty = shifty + speed
        noise:send("shifty", shifty)
    end
    if love.keyboard.isDown("left") then
        shiftx = shiftx - speed
        noise:send("shiftx", shiftx)
    end
    if love.keyboard.isDown("right") then
        shiftx = shiftx + speed
        noise:send("shiftx", shiftx)
    end
    if love.keyboard.isDown("=") then
        freq = freq - .1
        noise:send("freq",freq)
    end
    if love.keyboard.isDown("-") then
        freq = freq + .1
        noise:send("freq",freq)
    end
    if love.keyboard.isDown("f11") then
        falloff = falloff + .1
        noise:send("falloff",falloff)
    end
    if love.keyboard.isDown("f12") then
        falloff = falloff - .1
        noise:send("falloff",falloff)
    end
    
end


function love.draw()
    -- draw a full screen rectangle using the effect 
    love.graphics.points(stars)
    love.graphics.setShader(noise)
    love.graphics.setBlendMode("add")
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(),love.graphics.getHeight())
    love.graphics.setShader()
    love.graphics.print(love.timer.getFPS(),0,0)
end