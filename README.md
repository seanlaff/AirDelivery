AirDelivery
===========

JC2-MP addon that allows players to deliver packages by plane, runway to runway.

This is a rough framework for "taxi" stlye delivery missions that I started this project to help familiaze myself with the JC2MP API.  There's next to no polish but I figured others might gain something from it. Feel free to modify/copy/interpret.

#### Usage

- /ad to start a missions (there's only two, spawns you at an airfield with a plane and gives you a destination)
- /adquit to end your current mission

#### Features

- Choosing a random "mission" from a list, checking for a clear runway
- Spawning a player at an open runway in the given vehicle
- Vehicle cleanup during module crash/mission completion
- Radius and speed checks to confirm landing

#### Unimplemented Features

- Varrying difficulty missions (small forrest runways, different planes)
- Timed missions
- Data structure for Airfields
- Runway visualization (if VFR isn't already on the server)
- Player reward for succesful deliveries
- Better "hitbox" for runways (currently just a large radius)
- Client-side GUI (waypoints, arrows, package/passenger indicator)
- SAM site enemies
- Parachute package drop missions
- Bombing missions
- Chaining missions together (Crazy-Taxi style)


