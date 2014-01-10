for f in $1/*/findzero.m
do
cp -n $f "${f/.m/Org.m}"
cp "${f/.m/Org.m}" temp.txt
sed s/figure/"scrsz=get\(0,\'ScreenSize\'\)\;figure\(\'Position\',[0.25*scrsz(3) scrsz(4) 0.25*scrsz(3) 0.5*scrsz(4)]\);"/ temp.txt > temp1.txt
mv temp1.txt $f
done

for f in $1/*/findzeroOrg.m
do
sed s/"scrsz=get(0,'ScreenSize');figure('Position',\[0.25\*scrsz(3) scrsz(4) 0.25\*scrsz(3) 0.5\*scrsz(4)\]);"/figure/ $f > temp3.txt
sed s/findzero\(/findzeroOrg\(/ temp3.txt > $f
done


for f in $1/*/phaseplot.m
do
cp -n $f "${f/.m/Org.m}"
sed s/figure/"\%figure"/ $f > temp.txt
sed s/clear/"\%clear"/ temp.txt > temp1.txt
sed s/close/"\%closer"/ temp1.txt > temp.txt
mv temp.txt $f
done

rm *temp*.txt
