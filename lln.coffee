context = document.getElementById("canvas").getContext('2d')
context.translate(0.5, 0.5)

drawAxes = ->
   context.moveTo(50, 25)
   context.lineTo(50, 350)
   context.lineTo(575, 350)
   context.stroke()


drawYAxisLabels = ->
   yCoord = 300
   for i in [0..5] by 1
      currentY = yCoord - (50 * i)
      context.moveTo(46, currentY)
      context.lineTo(54, currentY)
      context.fillText(i + 1, 35, currentY + 4)
   context.stroke()


drawXAxisLabels = (numRolls) ->
   context.beginPath()
   xCoord = 100
   for i in [0..9] by 1
      currentX = xCoord + (50 * i)
      context.moveTo(currentX, 346)
      context.lineTo(currentX, 354)
      
      label = numRolls / 10 * (i + 1)
      labelAsNum = parseInt(label)
      horizontalCentering = 6
      if label < 10
         horizontalCentering = 3
      else if label >= 100
         horizontalCentering = 10

      context.fillText(label, currentX - horizontalCentering, 365)

   context.setLineDash([0, 0])
   context.strokeStyle = "#000"
   context.stroke()


drawExpectedValueLine = ->
   context.beginPath()
   context.moveTo(50, 175)
   context.setLineDash([5, 2])
   context.lineTo(575, 175)
   context.strokeStyle = "#888"
   context.stroke()


drawGraph = ->
   context.beginPath()
   context.font = "bold 12px sans-serif"
   context.strokeStyle = "#000"
   context.setLineDash([0, 0])
   context.lineWidth = 2
   
   drawAxes()
   drawYAxisLabels()
   drawExpectedValueLine()   


# Simulate a die roll, calculate the running average value and update the graph
rollDie = (currRoll, runningSum, numRolls) ->
   
   if currRoll == numRolls
      $("#runBtn").prop("disabled", false);
   else
      currRoll += 1
      result = Math.floor(Math.random() * 6 + 1)
      runningSum += result
      $("#dieImg").attr("src", result + ".png");
            
      context.lineTo(50 + (525 / numRolls * currRoll), 350 - ((runningSum / currRoll) * 50))
      context.stroke()
   
      setTimeout( ->
         rollDie(currRoll, runningSum, numRolls)
       100)
   
init = ->
   drawGraph()
   canvas = document.getElementById('canvas');
   runBtn = $("#runBtn")
   
   runBtn.click( ->
      runBtn.prop("disabled", true);
      context.clearRect(0, 0, canvas.width, canvas.height);
      drawGraph()
      numRolls = parseInt($("input:radio[name ='numRolls']:checked").val())
      drawXAxisLabels(numRolls)
      context.beginPath()
      context.moveTo(50, 350)
      rollDie(0, 0, numRolls)
   )

   
$(document).ready -> init()


