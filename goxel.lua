filename = ("/goxels/converted.txt")
mx = 0
my = 0
mz = 1
cx = {}
cy = {}
cz = {}
-- Holt die Länge aller Seiten X, Y, Z
function readGoxelFile()
  file = fs.open(filename, "r")
  local abgerufen = false
  repeat -- Schleife bis zum Dateiende
    local line = file.readLine()
    local x = 1
    if abgerufen == false then
      mx = (string.len(line))
      abgerufen = true
    end
    if line then --Ist noch was in der Line
      -- ist die Zeilenlänge größer als X
      if string.len(line) > x then
        if line ~= nil then
          --print(string.len(line))
          my = my + 1
        end
      else
        mz = mz + 1    
      end
      x = 1
    end
  until line == nil
end

function getLuaList(nx, ny, nz)
  file = fs.open(filename, "r")  
  --liest den ersten 2-Dim Block
  counter_z= 1
  for z = 1, nz, 1 do
  cz[counter_z] = {}
  counter_y = 1
  for y = 1, ny, 1 do
    cy[counter_y] = {}
    local line = file.readLine()
    counter_x = 1
    for x = 1, nx*2, 2 do   
      cx[counter_x] = {}
      -- Fügt X Werte in die Tabelle
      cx[counter_x] = string.sub(line,x,x)
      counter_x = counter_x + 1
    end 
    table.insert(cy[counter_y], cx) -- Fügt cy in cx
  end
  -- Es muss eine Zeile übersprungen werden
  table.insert(cz[counter_z], cy)
  local line = file.readLine()
  end
end

readGoxelFile()
mx = ((mx) / 2)
mz = (mz)
my = my / mz
-- Richtigen Werte
real_x = mx
real_y = my
real_z = mz

-- Größe der Matrix wird festgelegt
local n_x, n_y, n_z = real_x+1, real_y+1, real_z+1
local n_xy = n_x * n_y

-- Setzt an die gewünschte Position einen Wert
function setValue(t, x, y, z, value)
  assert(x > 0 and x < n_x)
  assert(y > 0 and y < n_y)
  assert(z > 0 and z < n_z)
  t[((z-1) * n_xy) + ((y-1) * n_z) + x] = value
end

-- Holt sich den Wert aus einer Position
function getValue(t, x, y, z)
  assert(x > 0 and x < n_x)
  assert(y > 0 and y < n_y)
  assert(z > 0 and z < n_z)
  return t[((z-1) * n_xy) + ((y-1) * n_z) + x]
end

-- Initialisiert und alloziert die 3-Dimensionale Matrix
t = { }
-- Fügt in den 3-Dimensionalen Würfel 0 auf jede Position
for z = 1, real_z, 1 do
  for y = 1, real_y, 1 do
    for x = 1, real_x, 1 do
      setValue(t, x, y, z, "0")
    end
  end
end

mc = {}
-- Ab jetzt exisiert die 3-Dimensionale Matrix
-- Jetzt muss die Information wo ein block plaziert wird in die Matrix

function changeToRightTurtle()
  turtle.turnRight()
  turtle.dig()
  turtle.forward()
  turtle.turnRight()
  turtle.dig()
end

function changeToLeftTurtle()
  turtle.turnLeft()
  turtle.dig()
  turtle.forward()
  turtle.turnLeft()
  turtle.dig()
end

function goBackTurtle(mystatus)
  --print("Goback")
  -- -- -- Zurück zum endpunkt Anfang -- -- --
  -- Y-Ebene beendet
  -- Entweder die Y richtung zurück...
  if mystatus == false then
    -- wenn false dann y
    turtle.turnLeft()
    for y = 1, real_y, 1 do
      turtle.dig()
      turtle.forward()
    end
    turtle.turnRight()
  end

  -- Oder die Y UND X Richtung zurück
  if mystatus == true then
    -- wenn true dann y und x
    turtle.turnRight()
    for y = 1, real_y, 1 do
      turtle.dig()
      turtle.forward()
    end
    turtle.turnLeft()
    for x = 1, real_x-1, 1 do
      turtle.dig()
      turtle.forward()
    end
    turtle.turnLeft()
    turtle.turnLeft()
  end
end

function setPixelInMatrix(nx, ny, nz)
  local x_coord = 1
  local y_coord = 1
  local z_coord = 1
  file = fs.open(filename, "r")
  switch_direction = false
  richtungswechsel = false
  turtle.up()
  repeat -- Schleife bis zum Dateiende

    local line = file.readLine()
    local x = 1
    if line then --Ist noch was in der Line
      -- ist die Zeilenlänge größer als X
      if string.len(line) > x then
        if line ~= nil then
          if y_coord > ny then
            y_coord = 1
          end
          if x_coord > nx then
            x_coord = 1
          end

          -- RICHTUNG 1 ------
          if richtungswechsel == false then
            for x = 1, nx*2, 2 do   
              --print("false",x+1, nx*2) 
              if tonumber(string.sub(line,x,x)) == 1 then
                --setValue(mc, x_coord, y_coord, z_coord, "1")
                -- Turtle Algo Start X --
                turtle.dig()
                turtle.placeDown()
                turtle.dig()
                if x+1 ~= nx*2 then
                  turtle.forward()
                end
                -- Turtle Algo Ende X--
              else
                --setValue(mc, x_coord, y_coord, z_coord, "0")
                turtle.dig()
                if x+1 ~= nx*2 then
                  turtle.forward()
                end
              end
              x_coord = x_coord + 1
            end
          else
            -- RICHTUNG 2 ------
            for x = nx*2-1, 0, -2 do  
              --print("true",x+1, nx*2-1) 
              if tonumber(string.sub(line,x,x)) == 1 then
                --setValue(mc, x_coord, y_coord, z_coord, "1")
                -- Turtle Algo Start X --
                turtle.dig()
                turtle.placeDown()
                turtle.dig()
                if 2 < x then
                  turtle.forward()
                end
                -- Turtle Algo Ende X--
              else
                --setValue(mc, x_coord, y_coord, z_coord, "0")
                turtle.dig()
                if 2 < x then
                  turtle.forward()
                end
              end
              x_coord = x_coord + 1
            end
          end
          if richtungswechsel == false then
            richtungswechsel = true
          else
            richtungswechsel = false
          end
          -- Turtle Algo Start Y --
          if switch_direction == false then
            changeToRightTurtle()
            switch_direction = true
          else
            changeToLeftTurtle()
            switch_direction = false
          end
          -- Turtle Algo Ende Y -- 
          y_coord = y_coord + 1       
        end
      
      else 
        goBackTurtle(switch_direction)
        z_coord = z_coord  + 1
        print(z_coord)
        -- Tuttle einen Hoch Start Z --
        turtle.up()
        switch_direction = false
        -- Tuttle einen Hoch Ende  Z --
      end
      
      x = 1
    end
  --
  until line == nil
  -- 
end


-- Setze die Blöcke in die Matrix
setPixelInMatrix(real_x, real_y, real_z)



-- Nun beginnt das eigentliche Turtleprogramm
function gogoturtle()
  for z = 1, real_z, 1 do
    -- Tuttle einen Hoch Start Z --
    turtle.up()
    switch_direction = false
    -- Tuttle einen Hoch Ende  Z --
    for y = 1, real_y, 1 do
      for x = 1, real_x, 1 do 
        -- Turtle Algo Start X --
        turtle.dig()
        --print((getValue(mc, x, y, z)))
        if tonumber(getValue(mc, x, y, z)) == 1 then
          turtle.placeDown()
        end
        turtle.dig()
        turtle.forward()
        -- Turtle Algo Ende X--
      end
      -- Turtle Algo Start Y --
      if switch_direction == false then
        changeToRightTurtle()
        switch_direction = true
      else
        changeToLeftTurtle()
        switch_direction = false
      end
      -- Turtle Algo Ende Y --
    end
    
    goBackTurtle(switch_direction)
    -- -- -- Zurück zum endpunkt Ende -- -- --
  end
end

--gogoturtle()