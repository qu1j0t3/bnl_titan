/* Copyright (C) bootnecklad */
/* License to be confirmed */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_LEN 10 //maximum instruction length is 10 characters: jmp 0x0000
#define MOV_LEN 7 //length of move instruction: mov r,r
#define MED_LEN 6 //medium length: clr r
#define MIN_LEN 3 //minimum length: nop, add, sub, and, or, not, xor
#define OPER_ADDR 4 //hex address, eg FFFF
#define TRUE 1

char whole_ins[MAX_LEN + 1];
char ins[MIN_LEN + 1];
char operand_reg[1];
char operand_addr[OPER_ADDR];
char operand_byte[2];
char operand_2_byte[2];

void long_ins(char whole_ins[], char ins[], char operand_byte[], char operand_2_byte[])
{
   strncpy(ins, whole_ins, MIN_LEN); //chops up instruction from whole thing
   ins[MIN_LEN] = 0;
   //printf("%s\n", ins);
   
   //takes out address from long instructions
   int x;
   for(x=0; x<2; x++)
   {
      operand_byte[x] = whole_ins[x+6];
      operand_2_byte[x] = whole_ins[x+8];
   }

   //prints two address bytes out, as if in memory.
   operand_byte[2] = 0;
   operand_2_byte[2] = 0;
   //printf("%s\n%s\n", operand_byte, operand_2_byte);
}

void mov_ins(char whole_ins[], char ins[], char operand_2_byte[])
{
   strncpy(ins, whole_ins, MIN_LEN); //chops up instruction from whole thing
   ins[MIN_LEN] = 0;
   //printf("%s\n", ins);

   //gets operand from move instruction (registers)
   operand_byte[0] = whole_ins[4];
   operand_byte[1] = whole_ins[6];
   operand_byte[2] = 0;
   //printf("%s\n", operand_byte);
}

void med_ins(char whole_ins[], char ins[], char operand_reg[])
{
   strncpy(ins, whole_ins, MIN_LEN); //seperates instruction from operand
   ins[MIN_LEN] = 0;
   //printf("%s\n", ins);
   operand_reg[0] = whole_ins[4]; //extracts operand from whole instruction
   operand_reg[1] = 0;
   //printf("%s\n", operand_reg);
}

void short_ins(char whole_ins[], char ins[])
{
   strncpy(ins, whole_ins, MIN_LEN); //etc... instruction from whole thing
   ins[MIN_LEN] = 0;
   //printf("%s\n", ins);
}

void print_bytes()
{
   //FILE* out = fopen("output.bin","w");
   //etc
   //fclose(out);
}

void assemble(char ins[], char operand_byte[], char operand_2_byte[], char operand_reg[])
{
   //FILE* out = fopen("output.bin","w");
   //fclose(out);
}

int main()
{
   FILE* file = fopen("input.asm","r");
   
   int i;
   for(;;)
   {
      fgets(whole_ins, MAX_LEN + 1, file); //gets one line, whole instruction operand and all
   
      int len = strlen(whole_ins); //gets length of instruction, min, med or max.
   
      //allows for dectection of a comment, probably a better way of doing it.
      operand_reg[0] = whole_ins[0];
      operand_reg[1] = 0;
   
      if(strcmp(operand_reg,"/")==TRUE)
      {
         if(strcmp(operand_reg,"E")==TRUE)
        {
		   switch(len)
           {
              case MAX_LEN:
                 long_ins(whole_ins, ins, operand_byte, operand_2_byte);
				 assemble(ins, operand_byte, operand_2_byte, operand_reg);
                 break;
              case MED_LEN:
                 med_ins(whole_ins, ins, operand_reg);
				 assemble(ins, operand_byte, operand_2_byte, operand_reg);
                 break;
              case MIN_LEN+1:
                 short_ins(whole_ins, ins);
				 assemble(ins, operand_byte, operand_2_byte, operand_reg);
                 break;
              case MOV_LEN+1:
                 mov_ins(whole_ins, ins, operand_byte);
				 assemble(ins, operand_byte, operand_2_byte, operand_reg);
                 break;
              default:
                 printf("Invalid Instruction\n"); //should do something about this
                 fclose(file);
              return 0;
           }
        }
		else
		{
           printf("END.\n");
           fclose(file);
           return 0;
         }
      }
   }
   
   fclose(file);
   return 0;
}
