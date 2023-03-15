---
title: "Custeio ABC para Tomada de Decisões Gerenciais"
date: 2022-01-05
author: "Diego Rodrigues"
output: 
    html_document:
        toc: true
        keep_tex: true
        theme: united
        highlight: tango
        css: style.css
        df_print: kable
        keep_md: true
        includes:
            in_header: header.html
            after_body: footer.html
runtime: shiny
---




# Uha


```r
ggplot(custos_diretos, aes(x = Produto, y = Valor, fill = Custo)) + 
  geom_col() 
```

![](report_files/figure-html/unnamed-chunk-2-1.png)<!-- -->


