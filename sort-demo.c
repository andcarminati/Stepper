#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>




void mergesort(int vetor[], int auxiliar[], int inicial, int final){
		
		if(inicial < final){
			int meio = (inicial+final)/2;
			//divisao
			mergesort(vetor, auxiliar, inicial, meio);
			mergesort(vetor, auxiliar, meio+1, final);
			
			int esquerda = inicial;
			int direita = meio+1;
			int posicao_final = inicial;
			
			// conquista
			while((esquerda <= meio) && (direita <= final)){
				if(vetor[esquerda] < vetor[direita]){
						auxiliar[posicao_final++] = vetor[esquerda++];
				} else {
						auxiliar[posicao_final++] = vetor[direita++];
				}		
			}
			while(esquerda <= meio){
				auxiliar[posicao_final++] = vetor[esquerda++];
			}
			while(direita <= final){
				auxiliar[posicao_final++] = vetor[direita++];
			}			
			
			while(inicial <= final){
				vetor[inicial] = auxiliar[inicial];
				inicial++;
			}	
		}	
}
		

int main(int argc, char** argv){

	int i;
	int numeros[] = {12, 2, 10, 7, 5, 9, 6, 15, 4, 3, 2, 1, 21, 3};
	int tmp[14];

	mergesort(numeros, tmp, 0, 13);
	
        printf("\n");
	for(i = 0; i < 14; i++){
		printf("%d, ", numeros[i]);
	}	
	printf("\n");
	return 0;
}	


