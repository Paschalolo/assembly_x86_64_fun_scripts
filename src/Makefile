
OFILE =${FILE}.o
EXEC = ${FILE}
ASMFILE= ${FILE}.asm
push: 
	git add . && git commit -m "${MESSAGE}"  
online : 
	git push origin main
test : 
	echo ${HOM}
build : 
	echo file ${ASMFILE}  object file : ${OFILE}  Executable : ${EXEC}
	nasm -f elf64 -g -F stabs ${ASMFILE}
link : build 
	ld -o ${EXEC} ${OFILE}
run : link 
	./${EXEC}

