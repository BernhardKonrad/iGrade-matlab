iGrade-matlab
=============

Script to (pre-) grade Matlab assignments


Install
=============

~~~
git clone https://github.com/BernhardKonrad/iGrade-matlab.git
cd iGrade-matlab
~~~

Demo run
=============

You can run this script as-is by calling

~~~
iGrade('Monday',1)
~~~

from **Matlab**.

Usually you want to run the bash script in advance though:

~~~
bash changeFigLoc.sh Monday
~~~

and then 
~~~
iGrade('Monday',1)
~~~

in **Matlab**.


Pro Tip
=============

Before experimenting with changeFigLoc.sh (which changes many files at once) create  backup. Git is your friend.