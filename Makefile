all : exe

exe : mainTri.o tri.o
	gcc -o exe mainTri.o tri.o

mainTri.o : mainTri.c
	gcc -o mainTri.o -c mainTri.c
	
tri.o : tri.c
	gcc -o tri.o -c tri.c
	
clean :
	rm -rf *o
	
	shell : 
exe : ./appMeteo.sh
	./appMeteo.sh <option> -f<nom_fichier>

all : &(exe)

clean :
	$(RM) $EXEC)
