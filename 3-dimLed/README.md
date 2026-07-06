Learned:
    buttons and LED on my ECP5 Lattice FPGA are active low
    active low means that on means that the FPGA is driving low current to it so it can power on
    many systems use this active-low for some reason
    also learned about PWM (pulse width modulation)


Structure:
    Essentially, to dim, you need to flicker the light at superhuman speeds
    By doing so, you give the illusion that the light is dim
    I did this by creating a counter that goes from 0 => 255 and wraps around
    Then I created a brightness that can be set by pressing buttons (dim and brighten)
    I learned that from my previous project and used it to set the state variables
    Then I compared the counter < brightness and that allowed me to flicker the light

