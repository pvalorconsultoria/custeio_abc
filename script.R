if (!require("tidyverse")) install.packages("tidyverse")

# Carrega Bibliotecas
library(tidyr)
library(dplyr)
library(readr)
library(readxl)
library(stringr)
library(lubridate)
library(clipr)
library(ggplot2)
library(ggthemes)

cbPallete <- c("#03733F", "#7ABF9F", "#027333", "#B0D9C6", "#261616", "#F2F2F2")

scale_fill_manual(values=cbPallete)


custos_diretos <- read_excel("Base de Dados.xlsx", sheet = 1)
custos_departamentos <- read_excel("Base de Dados.xlsx", sheet = 2)
rateio_atividade <- read_excel("Base de Dados.xlsx", sheet = 3)
direcionadores <- read_excel("Base de Dados.xlsx", sheet = 4)

p <- ggplot(custos_diretos, aes(x = Produto, y = Valor, fill = Custo)) + 
  geom_col() +
  scale_fill_manual(values=cbPallete) +
  scale_y_continuous(labels = scales::dollar_format()) +
  ylab("Custos Diretos de Produção")

ggsave(p, filename = "custos_diretos.png")

ggplot(custos_departamentos, aes(x = Departamento, y = Valor, fill = Custo)) + 
  geom_col() 

rateio_atividade <- rateio_atividade %>%
  pivot_longer(
    cols = c("Depreciação",	"Aluguel",	"Mão de obra", "Materiais diversos",	"Manutenção"),
    names_to = "Custo",
    values_to = "Valor"
  )

custos_por_atividade <- rateio_atividade %>%
  left_join(custos_departamentos, by = c("Departamento", "Custo")) %>%
  mutate(
    Valor = Valor.x * Valor.y
  ) %>%
  group_by(Departamento, Atividade, Direcionadores) %>%
  summarize(
    Custo = sum(Valor, na.rm = TRUE)
  )

ggplot(custos_por_atividade, aes(x = Atividade, y = Custo, fill = Departamento)) +
  geom_col()

custo_atividade_produto <- direcionadores %>%
  right_join(custos_por_atividade, by = "Direcionadores") %>%
  group_by(Atividade) %>%
  mutate(Custo = Quantidade / sum(Quantidade) * Custo) %>%
  select(Produto, Atividade, Custo)
  
ggplot(custo_atividade_produto, aes(x = Produto, y = Custo, fill = Atividade)) +
  geom_col()



