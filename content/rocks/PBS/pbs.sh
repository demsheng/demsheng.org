#PBS -N sheng ##可以给任务一个名字,方便辨识
#PBS -l nodes=1:ppn=12 ##使用1节点，每个节点12核
vboxdaily push.py
vbox2jpg --dir=./data
convert -delay 100 ./data/*[0-9].jpg -loop 0 ./data/process.gif 



