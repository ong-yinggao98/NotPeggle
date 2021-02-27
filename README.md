# CS3217 Problem Set 4

**Name:** Ong Ying Gao

**Matric No:** A0201924N

## Tips
1. CS3217's docs is at https://cs3217.netlify.com. Do visit the docs often, as
   it contains all things relevant to CS3217.
2. A Swiftlint configuration file is provided for you. It is recommended for you
   to use Swiftlint and follow this configuration. We opted in all rules and
   then slowly removed some rules we found unwieldy; as such, if you discover
   any rule that you think should be added/removed, do notify the teaching staff
   and we will consider changing it!

   In addition, keep in mind that, ultimately, this tool is only a guideline;
   some exceptions may be made as long as code quality is not compromised.
3. Do not burn out. Have fun!

## Dev Guide
You may put your dev guide either in this section, or in a new file entirely.
You are encouraged to include diagrams where appropriate in order to enhance
your guide.

## Rules of the Game
Please write the rules of your game here. This section should include the
following sub-sections. You can keep the heading format here, and you can add
more headings to explain the rules of your game in a structured manner.
Alternatively, you can rewrite this section in your own style. You may also
write this section in a new file entirely, if you wish.

### Cannon Direction
> Please explain how the player moves the cannon.

To use the cannon, the player must first aim the cannon, then fire a round.

Simply drag your finger over the playing area (with the beach background) to your intended
target. The cannon will automatically point directly at that location. Be warned! The cannon
will not account for gravity when turning, that is on you to figure out.

When you are ready to fire, hit the button that says "LAUNCH". The launch button also shows
the number of shots you have left. Firing the cannon causes that number to decrement by 1,
and the cannon immediately launches a ball towards wherever you aimed at. Aim carefully before
you do, because if you run out of shots too soon you lose!

The launch button is disabled when your previously-fired round has not yet left the screen,
or when the game has already ended. However, you can continue to aim the cannon wherever
you like in preparation for the next shot.

### Win and Lose Conditions
> Please explain how the player wins/loses the game.

When you start a level, the game calculates the minimum score you must obtain in order to win.
This score is calculated by the number of pegs you have multiplied by 100.
The player must aim to hit this goal by hitting pegs every turn. The scoring system is as follows:
1. Blue - 100 points
1. Green - 100 points
1. Orange - 200 points.

You win so long you hit the minimum score within your allocated shots.

If you run out of shots before you hit the minimum score, you lose!

And don't try to start a game without any pegs, if none are found the game will leave you a nasty message.

### Power-Ups
Green pegs are worth as much as blue pegs in points, but they activate power-ups when hit.
The two power-ups are Space Blast and Spooky Ball (or rather their clones). Hitting green pegs cause
them to activate in order with Space Blast first, then Spooky Ball, then Space Blast again, so on so forth.
Power-ups can be activated multiple times in one round so long the ball continuously hits green pegs.

#### Space Blast
Space Blast causes pegs in the vicinity of the green peg to be highlighted instantly, effectively allowing you
to score lots of points with a single hit.

#### Spooky Ball
Spooky Ball gives the ball an extra life, respawning it back at the top when after it falls through the ground.
Its effect does not stack, i.e. activating Spooky Ball multiple times will not grant the cannon ball anymore
respawns while until it has fallen out of the game area and has respawned.

## Level Designer Additional Features

### Peg Rotation
Please explain how the player rotates the pegs.

### Peg Resizing
Please explain how the player resizes the pegs.

## Bells and Whistles
Please write all of the additional features that you have implemented so that
your grader can award you credit.

## Tests
If you decide to write how you are going to do your tests instead of writing
actual tests, please write in this section. If you decide to write all of your
tests in code, please delete this section.

## Written Answers

### Reflecting on your Design
> Now that you have integrated the previous parts, comment on your architecture
> in problem sets 2 and 3. Here are some guiding questions:
> - do you think you have designed your code in the previous problem sets well
>   enough?
> - is there any technical debt that you need to clean in this problem set?
> - if you were to redo the entire application, is there anything you would
>   have done differently?

Your answer here
