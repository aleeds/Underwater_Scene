## Andy + Evan's Underwater Graphics Project

We implemented many different features of the underwater environment.

___

#### Andy's description of the parts he Did

I implemented two different three dimensional L-Systems. One of them draws the coral, the other draws rocks. Both have very long rule sets. The rock LSystem is in fact a *very* minor modification of the coral LSystem. It is a very general LSystem that with simple modifications could be used to draw many different kinds of organic or organic systems.
I also implemented fish. These fish swim in a region, and it could be extended in many ways. For example, the fish colony itself could swim around. In fact, this was in the code, but I removed it for aesthetic purposes.

These are the three models present in the system (Coral, rock, fishes).

For the camera, I used the quaternion model, from the quaternion and spacial rotation Wikipedia page. As how it is now, the model suffers from gimlock (or whatever it is called(its gimbal lock, Andy). To move the camera, use the left click. You can rotate the camera using the right click.

Both WASD and the arrow keys work for the position movement.

I completed the texture mapping of a nontrivial shape (fish scales, on tori), and two non-trivial LSystems. 

#### Evan's description of the parts he did

I implemented a quad tree (originally for changing vertex density but was not needed for optimization) and used my own vertex and fragment shaders to render it as water. The displacement unfortunatly had to be done in object space because processing said "screw you".

I also implemented sound playing based partially on location (ie music constant, underwater sounds underwater, etc.)
