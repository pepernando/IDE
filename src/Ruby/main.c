#include <stdio.h>
#include <stdlib.h>

char token; /*variable gloabal*/

int exp(void);
int term(void);
int factor(void);

void error(void){
    fprint(stderr,"Error\n");
    exit(1);
}

void match(char expectedToken){
    if(token==expectedToken) token = getchar();
    else error();
}

int main(){
    int result;
    token = getchar();

    result = exp();
    if (token=='\n') // Verifica fin de linea
        printf("Result = %d\n",result);
    else
        error();
    return 0;
}

int exp(void){
    int temp = term();
    while((token=='+'||(token=='-')){
        switch (token){
        case '+': match('+');
            temp+=term();
            break;
        case '-': match('-');
            temp-=term;
            break;
        }
    }
    return temp;
}

int term(void)
{
    int temp = factor();
    while (token == '*'){
        match('*');
        temp*=factor();
    }
    return temp;
}

int factor(void){
    int temp;
    if(token=='('){
        match('(');
        temp = exp();
        match(')');
    }else if(isdigit(token)){
        ungetc(token,stdin);
        scanf("%d",&temp);
        token = getchar();
    }
    else error();
    return temp;
}