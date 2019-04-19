# Checkpoint Source Code Collection

Checkpoint is an unreleased interactive fiction game written by Stu Galley for Infocom.

Further information on Checkpoint:

* [An Overview of Border Zone](https://www.filfre.net/2015/11/border-zone/), an unrelated Spy game later released by Infocom
* [A Description of Checkpoint before Moonmist](https://www.filfre.net/2015/03/moonmist/)

__What is this Repository?__

This repository is a directory of source code for the incomplete Infocom game "Checkpoint", including a variety of files both used and discarded in the production of the game. It is written in ZIL (Zork Implementation Language), a refactoring of MDL (Muddle), itself a dialect of LISP created by MIT students and staff.

The source code was contributed anonymously and represents a snapshot of the Infocom development system at time of shutdown - there is no remaining way to compare it against any official version as of this writing, and so it should be considered canonical, but not necessarily the exact source code arrangement for production.

__Basic Information on the Contents of This Repository__

It is mostly important to note that there is currently no known way to compile the source code in this repository into a final "Z-machine Interpreter Program" (ZIP) file. There are .ZIP files in some of the Infocom Source Code repositories but they were there as of final spin-down of the Infocom Drive and the means to create them is currently lost.

Throughout its history, Infocom used a TOPS20 mainframe with a compiler (ZILCH) to create and edit language files - this repository is a mirror of the source code directory archive of Infocom but could represent years of difference from what was originally released.

In general, Infocom games were created by taking previous Infocom source code, copying the directory, and making changes until the game worked the way the current Implementor needed. Structure, therefore, tended to follow from game to game and may or may not accurately reflect the actual function of the code.

There are also multiple versions of the "Z-Machine" and code did change notably between the first years of Infocom and a decade later. Addition of graphics, sound and memory expansion are all slowly implemented over time.

__What is the Purpose of this Repository__

This collection is meant for education, discussion, and historical work, allowing researchers and students to study how code was made for these interactive fiction games and how the system dealt with input and processing. It is not considered to be under an open license. 

Researchers are encouraged to share their discoveries about the information in this source code and the history of Infocom and its many innovative employees.

__Some Trivia and Notes on this Repository__

After finishing Seastalker, (Galley) had the idea to write a Cold War espionage thriller, tentatively called Checkpoint: “You, an innocent train traveler in a foreign country, get mixed up with spies and have to be as clever as they to survive.” He struggled for six months with Checkpoint, almost as long as it took some Imps to create a complete game, before voluntarily shelving it: “The problem there was that the storyline wasn’t sufficiently well developed to make it really interesting. I guess I had a vision of a certain kind of atmosphere in the writing that was rather hard to bring off.” 

-- From "Moonmist", an article by Jimmy Maher (https://www.filfre.net/2015/03/moonmist/)

* The working title was "Spy", and this was also the working title of Border Zone. Therefore it is often reported that Border Zone is a refashioning of Spy/Checkpoint, but Marc Blank's cold-war thriller game was written entirely separate.
* Stu Galley turned his attention from this project to a game that would eventually become "Moonmist".

The compiled code in this repository (spy.zip and COMPILED/spy.z5) is not the checkpoint game, but rather a early version of Journey. The code here can be compiled if you would like to try the actual game.
