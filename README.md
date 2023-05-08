# ESTAP - Trabalho final
Proposta de Trabalho: Usando o UKF, adaptar a simulação e o filtro de modo a ter o mesmo sensor (range and bearing) mas contaminado de um erro de desalinhamento angular na montagem na base do robot e na escala de range. E no filtro estimar esses novos estados internos do sistema.

## Steps:
1. Adaptar código EKF para range and bearing
2. Matlab- Resultados
3. Adaptar código EKF para UKF
4. Matlab- Resultados
5. UKF com Range and bearing
6. Matlab- Resultados (comparar com resultados acima)
7.Estimar novos estados
8. Apresentação

#Como converter o filtro EKF em UKF, baseado no livro "Optimal Filtering with Kalman Filters and Smoothers" e na toolbox associada.

Em primeiro lugar, é importante entender que a principal diferença entre o EKF e o UKF é a maneira como a propagação da incerteza é tratada. No EKF, a incerteza é propagada linearmente usando uma aproximação de primeira ordem (série de Taylor), enquanto no UKF, a incerteza é propagada usando um conjunto de pontos de amostragem que representam a distribuição de probabilidade do estado.

- Para converter o filtro EKF em UKF, o primeiro passo é modificar a função de previsão (predict) do EKF para a função de previsão (predict) do UKF. Na função predict do UKF, a incerteza é propagada usando um conjunto de pontos de amostragem (chamados de sigma points) que são calculados a partir da média do estado atual e da matriz de covariância.

- Em seguida, é necessário atualizar a função de atualização (update) do filtro para a função de atualização (update) do UKF. Na função update do UKF, os sigma points são projetados nas medidas observadas e a média e matriz de covariância atualizadas são calculadas a partir desses pontos.

- Além disso, é necessário ajustar os parâmetros do UKF, como o número de sigma points a serem usados, o coeficiente de propagação de incerteza (kappa) e os pesos dos sigma points.

- Uma vez que a função predict e a função update do UKF foram modificadas e os parâmetros ajustados, é possível executar o filtro UKF na mesma maneira que o EKF.

- É importante realizar testes cuidadosos no filtro UKF modificado para garantir que a propagação da incerteza e a atualização estejam corretas e que os resultados estejam em concordância com as expectativas.



### Apresentação:
- UKF
  - Definição e uso
  - O que foi feito para o implementar
  - Resultados
-Range and Bearing
  - Definição e uso
  - O que foi feito para o implementar
  - Resultados
- Junção dos dois resultados
> **_NOTE:_**  Para mais informações sobre documentação e utilização do ukf tem neste link.
