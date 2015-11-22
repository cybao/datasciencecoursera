---
title       : MyNHLStars
subtitle    : A webapp to predict NHL player performance
author      : C. Bao
job         : 
framework   : io2012     # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [mathjax]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## The Motivation

- The National Hockey League (NHL) is one of the four major professional sports leagues in the US with millions of fans and billions of revenue each year
- Prediction of NHL players' performance affects teams' decision on player contracts
- More and more fans care about predicting NHL player performance due to the increasing popularity of fantasy sports and private hockey pools

--- 
## Is player performance predictable?
- The performance of an NHL player is largely related to his age and past statistics.
- Using player statistics data from the past ten years, we see there is a general trend of player offensive performance with respect to age (bottom left figure). Players, being a forward or a defenseman, typically mature in their late 20s.
- There is also some correlation between a player's performance in two consecutive seasons (bottom right figure).

![plot of chunk unnamed-chunk-1](assets/fig/unnamed-chunk-1-1.png) 

---

## What is MyNHLStars?
- [MyNHLStars](https://cybao.shinyapps.io/MyNHLStars) is a webapp which predicts NHL player performance based on their statistics from past seasons 
- Currently it fits a simple regression model to player's goal per game, assist per game and game played per season as a function of their position, age and corresponding statistics in a number of past seasons specified by the user. Then it will assign points to player's goals and assists based on user input
- Many improvements are planned for MyNHLStars: better predicative model for player performance, expand model to predict performance of rookie players (players with little past statistics),expand model to predict performance of goalies, expand model to display individual player data.

---
## MyNHLStars in Action
<img height='600' width='1000' src="assets/img/mynhlstars.png"/>




