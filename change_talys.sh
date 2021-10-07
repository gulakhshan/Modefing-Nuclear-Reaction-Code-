s2_old=1
a_old=12.43
v_old=185
w_old=25
rv_old=1.4
av_old=0.52
parameter_old1=-0.2
parameter_old2=+0.004
par=-1
num=8000
numMax=10001
while [ $num -lt $numMax ]
do
echo $num
echo ===========
s2_new=$(python -c "import random;print(random.uniform(1,1.9))")
rv_new=$(python -c "import random;print(random.uniform(1.2,1.6))")
av_new=$(python -c "import random;print(random.uniform(0.4,0.7))") 
a_new=$(python -c "import random;print(random.uniform(11.3,12.4))")
v_new=$(python -c "import random;print(random.uniform(140,220))")
w_new=$(python -c "import random;print(random.uniform(5,54))")
parameter_new1=$(python -c "import random;print(random.uniform(-0.2,-0.4))")
parameter1=$(python -c"import math;print($par * $parameter_new1)")
parameter_new=$(python -c "import random;print(random.uniform(0.004,0.006))")
parameter_new2=+$parameter_new
parameter2=$(python -c"import math;print(1 * $parameter_new2)")
echo $parameter1
echo $parameter2
echo $parameter_new1
echo $parameter_new2
cd /home/gula/TALYS3/bin
printf "$parameter1 $parameter2  $s2_new  $a_new  $v_new  $w_new  $rv_new  $av_new \n">> talys33_text.txt
#going to the input directory
cd /home/gula/TALYS3/bin
sed -i "8s/$s2_old/$s2_new/1" input
echo new s2_value = $s2_new
sed -i "9s/$a_old/$a_new/1" input
echo new a_value = $a_new

#going to the source directory
cd /home/gula/TALYS3/talys/source
sed -i "35s/$v_old/$v_new/1" opticalalpha.f
echo new V_value = $v_new
sed -i "38s/$w_old/$w_new/1" opticalalpha.f
echo new W_value = $w_new
sed -i "36s/$rv_old/$rv_new/1" opticalalpha.f
echo new rv_value = $rv_new
sed -i "37s/$av_old/$av_new/1" opticalalpha.f
echo new av_value = $av_new

sed -i "35s/$parameter_old1/$parameter_new1/1" opticalalpha.f
sed -i "38s/$parameter_old2/$parameter_new2/1" opticalalpha.f
echo new pararmeter1 = $parameter_new1
echo new pararmeter2 = $parameter_new2

# changing the path to the directory where talys.setup exist and compile it
cd /home/gula/TALYS3/talys
./talys.setup


# change the path to the directory where an excutable talys and input file exist. Do change the variable in the input file
cd /home/gula/TALYS3/bin
talys <input> output_changed_C${num}.dat
grep -i -A 66 'Production of Z= 42 A= 99 ( 99Mo) - Total' output_changed_C${num}.dat >placeholder
grep -i -A 4960 '2.08300E+00 0.00000E+00' placeholder > output_changed_C${num}.out
rm placeholder
rm *.tot
rm rp*
rm *.dat
grep -i -A 100 '# Angle       xs            Direct         Compound    c.s./Rutherford' aa0035.400ang.L00 >holder
grep -i -A 100 '0.0' holder > output_changed_35.4_C${num}.txt
rm *.L00
rm holder


# before exitting the loop go back to the directory where opticalalpha.f
cd /home/gula/TALYS3/talys/source
sed -i "37s/$av_new/$av_old/1" opticalalpha.f
sed -i "36s/$rv_new/$rv_old/1" opticalalpha.f
sed -i "38s/$parameter_new2/$parameter_old2/1" opticalalpha.f
sed -i "35s/$parameter_new1/$parameter_old1/1" opticalalpha.f
sed -i "38s/$w_new/$w_old/1" opticalalpha.f
sed -i "35s/$v_new/$v_old/1" opticalalpha.f


# before exitting the loop go back to the directory where input
cd /home/gula/TALYS3/bin
sed -i "9s/$a_new/$a_old/1" input
sed -i "8s/$s2_new/$s2_old/1" input


((num += 1))
done

echo I AM DONE
