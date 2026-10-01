$code = @'
package com.example.unitconverter

import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowDropDown
import androidx.compose.material3.Button
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableDoubleStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shadow
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.example.unitconverter.ui.theme.UnitConverterTheme
import java.util.Locale

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            UnitConverterTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    UnitConverter()
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun UnitConverter() {
    var inputValue by remember { mutableStateOf("") }
    var outputValue by remember { mutableStateOf("") }
    var inputUnit by remember { mutableStateOf("Select") }
    var outputUnit by remember { mutableStateOf("Meters(m)") }
    var iExpanded by remember { mutableStateOf(false) }
    var oExpanded by remember { mutableStateOf(false) }
    val conversionFactor = remember { mutableDoubleStateOf(1.00) }
    val oConversionFactor = remember { mutableDoubleStateOf(1.00) }
    val context = LocalContext.current
    var Expanded by remember { mutableStateOf(false) }
    var unitCategory by remember { mutableStateOf("Length") }
    var resultUnit by remember { mutableStateOf("m") }

    val customTextStyle = TextStyle(
        fontFamily = FontFamily.Cursive,
        fontSize = 36.sp,
        fontWeight = FontWeight.ExtraBold,
        color = Color(0xFF6200EE),
        letterSpacing = 2.sp,
        lineHeight = 42.sp,
        shadow = Shadow(
            color = Color.Gray,
            offset = Offset(3f, 3f),
            blurRadius = 5f
        )
    )

    fun convertTemperature(value: Double, fromUnit: String, toUnit: String): Double {
        val from = fromUnit.trim()
        val to = toUnit.trim()
        if (from == to) return value

        // Step 1: Convert input unit to Celsius
        val celsius = when {
            from.contains("Celsius", ignoreCase = true) || from.contains("°C") -> value
            from.contains("Fahrenheit", ignoreCase = true) || from.contains("°F") -> (value - 32.0) * 5.0 / 9.0
            from.contains("Kelvin", ignoreCase = true) || from.contains("K") -> value - 273.15
            else -> value
        }

        // Step 2: Convert Celsius to target unit
        return when {
            to.contains("Celsius", ignoreCase = true) || to.contains("°C") -> celsius
            to.contains("Fahrenheit", ignoreCase = true) || to.contains("°F") -> (celsius * 9.0 / 5.0) + 32.0
            to.contains("Kelvin", ignoreCase = true) || to.contains("K") -> celsius + 273.15
            else -> celsius
        }
    }

    fun convertUnits() {
        val inputValueDouble = inputValue.toDoubleOrNull() ?: 0.0
        val result = when (unitCategory) {
            "Length", "Weight" -> {
                (inputValueDouble * conversionFactor.doubleValue * 100 / oConversionFactor.doubleValue) / 100.0
            }
            "Temperature" -> {
                convertTemperature(inputValueDouble, inputUnit, outputUnit)
            }
            else -> 0.0
        }

        val roundedResult = String.format(Locale.US, "%.4f", result).toDouble()
        outputValue = roundedResult.toString()
    }

    Box(modifier = Modifier.fillMaxSize()) {
        // Attractive dynamic converter background
        ConverterBackground()

        Column(
            modifier = Modifier.fillMaxSize(),
            verticalArrangement = Arrangement.Top,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(modifier = Modifier.height(24.dp))

            // App Title
            Text(
                text = "Unit Converter",
                style = customTextStyle,
                modifier = Modifier.padding(16.dp)
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Input Value Field
            OutlinedTextField(
                value = inputValue,
                onValueChange = {
                    inputValue = it
                    // Check if input is valid (digits, negative sign, decimal point)
                    if (it.isEmpty() || it == "-" || it == "." || it == "-." || it.matches(Regex("^-?\\d*\\.?\\d*$"))) {
                        convertUnits()
                    } else {
                        Toast.makeText(context, "Enter Numeric Value", Toast.LENGTH_SHORT).show()
                    }
                },
                label = { Text("Enter Value") }
            )

            Spacer(modifier = Modifier.height(16.dp))

            // Category Selection Dropdown
            Box {
                Button(onClick = { Expanded = true }) {
                    Text(text = unitCategory)
                    Icon(
                        Icons.Default.ArrowDropDown,
                        contentDescription = "Arrow Down"
                    )
                }
                DropdownMenu(expanded = Expanded, onDismissRequest = { Expanded = false }) {
                    DropdownMenuItem(
                        text = { Text("Length") },
                        onClick = {
                            Expanded = false
                            unitCategory = "Length"
                            inputUnit = "Select"
                            outputUnit = "Meters(m)"
                            resultUnit = "m"
                            conversionFactor.doubleValue = 1.0
                            oConversionFactor.doubleValue = 1.0
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = { Text("Weight") },
                        onClick = {
                            Expanded = false
                            unitCategory = "Weight"
                            inputUnit = "Select"
                            outputUnit = "Gram(g)"
                            resultUnit = "g"
                            conversionFactor.doubleValue = 1.0
                            oConversionFactor.doubleValue = 1.0
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = { Text("Temperature") },
                        onClick = {
                            Expanded = false
                            unitCategory = "Temperature"
                            inputUnit = "Celsius(°C)"
                            outputUnit = "Fahrenheit(°F)"
                            resultUnit = "°F"
                            convertUnits()
                        }
                    )
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Row containing Unit Dropdowns (Length, Weight, or Temperature)
            Row {
                if (unitCategory == "Length") {
                    // Length: Input Unit
                    Box {
                        Button(onClick = { iExpanded = true }) {
                            Text(text = inputUnit)
                            Icon(Icons.Default.ArrowDropDown, contentDescription = "Arrow Down")
                        }
                        DropdownMenu(expanded = iExpanded, onDismissRequest = { iExpanded = false }) {
                            DropdownMenuItem(
                                text = { Text("Millimeters(mm)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Millimeters(mm)"
                                    conversionFactor.doubleValue = 0.001
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Centimeters(cm)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Centimeters(cm)"
                                    conversionFactor.doubleValue = 0.01
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Meters(m)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Meters(m)"
                                    conversionFactor.doubleValue = 1.0
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Kilometers(km)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Kilometers(km)"
                                    conversionFactor.doubleValue = 1000.0
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Feet(ft)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Feet(ft)"
                                    conversionFactor.doubleValue = 0.3048
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Inch(in)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Inch(in)"
                                    conversionFactor.doubleValue = 0.0254
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Yard(yd)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Yard(yd)"
                                    conversionFactor.doubleValue = 0.9144
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Miles(mi)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Miles(mi)"
                                    conversionFactor.doubleValue = 1609.344
                                    convertUnits()
                                }
                            )
                        }
                    }

                    Spacer(modifier = Modifier.width(16.dp))

                    // Length: Output Unit
                    Box {
                        Button(onClick = { oExpanded = true }) {
                            Text(text = outputUnit)
                            Icon(Icons.Default.ArrowDropDown, contentDescription = "Arrow Down")
                        }
                        DropdownMenu(expanded = oExpanded, onDismissRequest = { oExpanded = false }) {
                            DropdownMenuItem(
                                text = { Text("Millimeters(mm)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Millimeters(mm)"
                                    resultUnit = "mm"
                                    oConversionFactor.doubleValue = 0.001
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Centimeters(cm)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Centimeters(cm)"
                                    resultUnit = "cm"
                                    oConversionFactor.doubleValue = 0.01
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Meters(m)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Meters(m)"
                                    resultUnit = "m"
                                    oConversionFactor.doubleValue = 1.00
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Kilometers(km)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Kilometers(km)"
                                    resultUnit = "km"
                                    oConversionFactor.doubleValue = 1000.0
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Feet(ft)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Feet(ft)"
                                    resultUnit = "ft"
                                    oConversionFactor.doubleValue = 0.3048
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Inch(in)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Inch(in)"
                                    resultUnit = "in"
                                    oConversionFactor.doubleValue = 0.0254
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Yard(yd)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Yard(yd)"
                                    resultUnit = "yd"
                                    oConversionFactor.doubleValue = 0.9144
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Miles(mi)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Miles(mi)"
                                    resultUnit = "mi"
                                    oConversionFactor.doubleValue = 1609.344
                                    convertUnits()
                                }
                            )
                        }
                    }
                } else if (unitCategory == "Weight") {
                    // Weight: Input Unit
                    Box {
                        Button(onClick = { iExpanded = true }) {
                            Text(text = inputUnit)
                            Icon(Icons.Default.ArrowDropDown, contentDescription = "Arrow Down")
                        }
                        DropdownMenu(expanded = iExpanded, onDismissRequest = { iExpanded = false }) {
                            DropdownMenuItem(
                                text = { Text("Milligram(mg)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Milligram(mg)"
                                    conversionFactor.doubleValue = 0.001
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Gram(g)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Gram(g)"
                                    conversionFactor.doubleValue = 1.0
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("KiloGram(kg)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "KiloGram(kg)"
                                    conversionFactor.doubleValue = 1000.0
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Ton(metric)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Ton(metric)"
                                    conversionFactor.doubleValue = 1000000.0
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Pound(lb)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Pound(lb)"
                                    conversionFactor.doubleValue = 453.592
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Ounce(oz)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Ounce(oz)"
                                    conversionFactor.doubleValue = 28.3495
                                    convertUnits()
                                }
                            )
                        }
                    }

                    Spacer(modifier = Modifier.width(16.dp))

                    // Weight: Output Unit
                    Box {
                        Button(onClick = { oExpanded = true }) {
                            Text(text = outputUnit)
                            Icon(Icons.Default.ArrowDropDown, contentDescription = "Arrow Down")
                        }
                        DropdownMenu(expanded = oExpanded, onDismissRequest = { oExpanded = false }) {
                            DropdownMenuItem(
                                text = { Text("Milligram(mg)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Milligram(mg)"
                                    resultUnit = "mg"
                                    oConversionFactor.doubleValue = 0.001
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Gram(g)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Gram(g)"
                                    resultUnit = "g"
                                    oConversionFactor.doubleValue = 1.00
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("KiloGram(kg)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "KiloGram(kg)"
                                    resultUnit = "kg"
                                    oConversionFactor.doubleValue = 1000.0
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Ton(metric)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Ton(metric)"
                                    resultUnit = "metric"
                                    oConversionFactor.doubleValue = 1000000.0
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Pound(lb)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Pound(lb)"
                                    resultUnit = "lb"
                                    oConversionFactor.doubleValue = 453.592
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Ounce(oz)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Ounce(oz)"
                                    resultUnit = "oz"
                                    oConversionFactor.doubleValue = 28.3495
                                    convertUnits()
                                }
                            )
                        }
                    }
                } else if (unitCategory == "Temperature") {
                    // Temperature: Input Unit
                    Box {
                        Button(onClick = { iExpanded = true }) {
                            Text(text = inputUnit)
                            Icon(Icons.Default.ArrowDropDown, contentDescription = "Arrow Down")
                        }
                        DropdownMenu(expanded = iExpanded, onDismissRequest = { iExpanded = false }) {
                            DropdownMenuItem(
                                text = { Text("Celsius(°C)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Celsius(°C)"
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Fahrenheit(°F)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Fahrenheit(°F)"
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Kelvin(K)") },
                                onClick = {
                                    iExpanded = false
                                    inputUnit = "Kelvin(K)"
                                    convertUnits()
                                }
                            )
                        }
                    }

                    Spacer(modifier = Modifier.width(16.dp))

                    // Temperature: Output Unit
                    Box {
                        Button(onClick = { oExpanded = true }) {
                            Text(text = outputUnit)
                            Icon(Icons.Default.ArrowDropDown, contentDescription = "Arrow Down")
                        }
                        DropdownMenu(expanded = oExpanded, onDismissRequest = { oExpanded = false }) {
                            DropdownMenuItem(
                                text = { Text("Celsius(°C)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Celsius(°C)"
                                    resultUnit = "°C"
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Fahrenheit(°F)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Fahrenheit(°F)"
                                    resultUnit = "°F"
                                    convertUnits()
                                }
                            )
                            DropdownMenuItem(
                                text = { Text("Kelvin(K)") },
                                onClick = {
                                    oExpanded = false
                                    outputUnit = "Kelvin(K)"
                                    resultUnit = "K"
                                    convertUnits()
                                }
                            )
                        }
                    }
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Result Text
            Text(
                text = "Result: $outputValue $resultUnit",
                style = TextStyle(
                    fontSize = 32.sp,
                    fontWeight = FontWeight.ExtraBold,
                    brush = Brush.linearGradient(
                        colors = listOf(Color(0xFF4CAF50), Color(0xFF81C784))
                    ),
                    fontFamily = FontFamily.Cursive,
                    letterSpacing = 1.8.sp,
                    lineHeight = 38.sp,
                    textAlign = TextAlign.Center,
                    shadow = Shadow(
                        color = Color(0x80000000),
                        offset = Offset(2f, 2f),
                        blurRadius = 8f
                    )
                ),
                modifier = Modifier.padding(16.dp)
            )
        }
    }
}

// Attractive Background for the Converter
@Composable
fun ConverterBackground() {
    Box(modifier = Modifier.fillMaxSize()) {
        Canvas(modifier = Modifier.fillMaxSize()) {
            val width = size.width
            val height = size.height

            // Background subtle gradient
            drawRect(
                brush = Brush.verticalGradient(
                    colors = listOf(
                        Color(0xFFF3E5F5), // Light purple tint
                        Color(0xFFEDE7F6),
                        Color(0xFFE8EAF6)  // Light indigo tint
                    )
                )
            )

            // Soft glowing ambient circles
            drawCircle(
                brush = Brush.radialGradient(
                    colors = listOf(Color(0x266200EE), Color.Transparent),
                    center = Offset(width * 0.15f, height * 0.15f),
                    radius = width * 0.5f
                ),
                center = Offset(width * 0.15f, height * 0.15f),
                radius = width * 0.5f
            )

            drawCircle(
                brush = Brush.radialGradient(
                    colors = listOf(Color(0x1F4CAF50), Color.Transparent),
                    center = Offset(width * 0.85f, height * 0.75f),
                    radius = width * 0.6f
                ),
                center = Offset(width * 0.85f, height * 0.75f),
                radius = width * 0.6f
            )

            // Subtle ruler ticks on the left edge (Unit converter motif)
            val tickStep = 10.dp.toPx()
            var tickY = 0f
            var count = 0
            while (tickY <= height) {
                val isMajor = count % 5 == 0
                val tickLength = if (isMajor) 20.dp.toPx() else 10.dp.toPx()
                drawLine(
                    color = Color(0x226200EE),
                    start = Offset(0f, tickY),
                    end = Offset(tickLength, tickY),
                    strokeWidth = if (isMajor) 2f else 1f
                )
                tickY += tickStep
                count++
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun UnitConverterPreview() {
    UnitConverterTheme {
        UnitConverter()
    }
}
'@

$target = "app\src\main\java\com\example\unitconverter\MainActivity.kt"
[System.IO.File]::WriteAllText($target, $code, [System.Text.Encoding]::UTF8)
Write-Output "Written $($code.Length) characters to $target"
