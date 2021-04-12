Feature: 2 Fills Examples into Tables
Cucumberish shall support filling examples into tables

Scenario Outline: Tables with Examples
Given a table with examples
|option1|option2|
|<example1>|<example2>|
When cucumber is executed
Then option1 value <example1> has been passed through
And option2 value <example2> has been passed through

Examples:
|example1|example2|
|foo|bar|
|foobar1|foobar2|
