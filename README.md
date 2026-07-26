<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MMH Culculater</title>
    <style>
        /* التنسيق (CSS) */
        body { display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; background-color: #f0f2f5; font-family: sans-serif; }
        .calculator { background-color: #333; padding: 20px; border-radius: 15px; box-shadow: 0 10px 25px rgba(0,0,0,0.3); width: 320px; }
        .brand { color: #fff; text-align: center; margin-bottom: 15px; font-weight: bold; font-size: 1.2rem; }
        #display { width: 100%; height: 60px; font-size: 2rem; text-align: right; margin-bottom: 20px; padding: 10px; box-sizing: border-box; border: none; border-radius: 5px; background-color: #eee; }
        .buttons { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; }
        button { height: 60px; font-size: 1.5rem; border: none; border-radius: 10px; cursor: pointer; background-color: #555; color: white; }
        .btn-op { background-color: #f39c12; }
        .btn-equal { background-color: #27ae60; grid-row: span 2; height: 130px; }
        .btn-clear { background-color: #c0392b; }
        .btn-zero { grid-column: span 2; }
    </style>
</head>
<body>
    <div class="calculator">
        <div class="brand">MMH Culculater</div>
        <input type="text" id="display" disabled>
        <div class="buttons">
            <button onclick="clearDisplay()" class="btn-clear">C</button>
            <button onclick="deleteLast()">DEL</button>
            <button onclick="appendToDisplay('/')" class="btn-op">/</button>
            <button onclick="appendToDisplay('*')" class="btn-op">×</button>
            <button onclick="appendToDisplay('7')">7</button>
            <button onclick="appendToDisplay('8')">8</button>
            <button onclick="appendToDisplay('9')">9</button>
            <button onclick="appendToDisplay('-')" class="btn-op">-</button>
            <button onclick="appendToDisplay('4')">4</button>
            <button onclick="appendToDisplay('5')">5</button>
            <button onclick="appendToDisplay('6')">6</button>
            <button onclick="appendToDisplay('+')" class="btn-op">+</button>
            <button onclick="appendToDisplay('1')">1</button>
            <button onclick="appendToDisplay('2')">2</button>
            <button onclick="appendToDisplay('3')">3</button>
            <button onclick="calculate()" class="btn-equal">=</button>
            <button onclick="appendToDisplay('0')" class="btn-zero">0</button>
            <button onclick="appendToDisplay('.')">.</button>
        </div>
    </div>

    <script>
        /* البرمجة (JavaScript) */
        let displayValue = '';
        function appendToDisplay(v) { displayValue += v; document.getElementById('display').value = displayValue; }
        function clearDisplay() { displayValue = ''; document.getElementById('display').value = ''; }
        function deleteLast() { displayValue = displayValue.slice(0, -1); document.getElementById('display').value = displayValue; }
        function calculate() {
            try {
                displayValue = eval(displayValue).toString();
                document.getElementById('display').value = displayValue;
            } catch {
                document.getElementById('display').value = 'Error';
                displayValue = '';
            }
        }
    </script>
</body>
</html>
