Feature: Handle Exact Matches
Cucumberish shall support matching exact strings, beginning and end

Scenario: Exact and Inexact Matches
Given a step that matches beginning and end
And a step that just matches strings
When cucumber is executed
Then the exact match passed
And the inexact match passed