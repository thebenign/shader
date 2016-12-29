//old GLSL


        
        // scale the screen coordinates to scale the noise
            /*number nx = (screen.x/1200.0 - .5)*freq+(shiftx+seed);
            number ny = (screen.y/1200.0 - .5)*freq+(shifty+seed);
            number noise = 0;
            number divisor = 0;
            number div_total = 0;
            
            for (int i = 0; i <= oct; i++)
            {
                //divisor = (pow(2, i) > 0) ? pow(2.0, i-1) : 1;
                divisor = pow(2.0 ,float(i));
                noise += .5*(.5+perlin2d(vec2(divisor*nx,divisor*ny)))/divisor;
                div_total += (1/divisor);
            }
            
            // the noise is between -1 and 1, so scale it between 0 and 1
            
            //noise = noise * 0.5 + 0.5;
            
            noise /= div_total;
            noise = pow(max(noise,0),float(falloff));*/
            