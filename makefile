# Target: executable
all: tinyC2_22CS30040_22CS30048 input_22CS30040_22CS30048.c
	./tinyC2_22CS30040_22CS30048 < input_22CS30040_22CS30048.c > output.txt

# Rule for the executable
tinyC2_22CS30040_22CS30048: tinyC2_22CS30040_22CS30048.c tinyC2_22CS30040_22CS30048.l tinyC2_22CS30040_22CS30048.y
	flex tinyC2_22CS30040_22CS30048.l
	bison -d tinyC2_22CS30040_22CS30048.y
	gcc -o tinyC2_22CS30040_22CS30048 tinyC2_22CS30040_22CS30048.c lex.yy.c tinyC2_22CS30040_22CS30048.tab.c -lfl 

# Rule for cleaning up generated tinyC2_22CS30040_22CS30048s
clean:
	rm -f *.tab.* tinyC2_22CS30040_22CS30048 lex.yy.c output.txt