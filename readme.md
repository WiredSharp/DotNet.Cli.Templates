# TODO

find a way to generate a solution with template

in template.json, the following does not work (2019-06-22)
``` json
  "postActions": [
    {
      "description": "create solution.",
      "args": {
        "executable": "dotnet",
        "args": "new sln"
      },
      "manualInstructions": [
        { "text": "Run 'dotnet new sln'" }
      ],
      "actionId": "3A7C4B45-1F5D-4A30-959A-51B88E82B5D2",
      "continueOnError": false
    },
    {
      "description": "add projects to solution",
      "manualInstructions": [
        { "text": "Run 'dotnet sln add **\\*.csproj'" }
      ],
      "actionId": "D396686C-DE0E-4DE6-906D-291CD29FC5DE",
      "args": {
        "files": "1"
      },
      "continueOnError": true
    }
  ]
```