package com.example.unitconverter

import android.os.Build
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
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
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shadow
import androidx.compose.ui.text.style.TextAlign
import com.example.unitconverter.ui.theme.UnitConverterTheme
//import java.time.format.TextStyle
import kotlin.time.times
import kotlin.math.roundToInt

//import kotlinx.coroutines.flow.internal.NoOpContinuation.context
//import kotlin.coroutines.jvm.internal.CompletedContinuation.context

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            UnitConverterTheme {
                // A surface container using the 'background' color from the theme
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

@Composable
fun UnitConverter() {

    var inputValue by remember {mutableStateOf("")}
    var outputValue by remember {mutableStateOf("")}
    var inputUnit by remember {mutableStateOf("Select")}
    var outputUnit by remember {mutableStateOf("Meters")}
    var iExpanded by remember {mutableStateOf(false)}
    var oExpanded by remember {mutableStateOf(false)}
    val conversionFactor = remember { mutableDoubleStateOf(1.00) }
    val oConversionFactor = remember { mutableDoubleStateOf(1.00) }
    val context = LocalContext.current

    val customTextStyle = TextStyle(
        fontFamily = FontFamily.Cursive,  // Elegant cursive font
        fontSize = 36.sp,                 // Slightly increased font size for emphasis
        fontWeight = FontWeight.ExtraBold, // Stronger emphasis on text
        color = Color(0xFF6200EE),         // A stylish deep purple color
        letterSpacing = 2.sp,              // Extra spacing between letters for better readability
        lineHeight = 42.sp,                // Adjusted line height for better aesthetics
        background = Color(0xFFEDE7F6),    // Soft lavender background for a premium feel
        shadow = Shadow(                   // Adds a shadow effect for a stylish 3D look
            color = Color.Gray,
            offset = Offset(3f, 3f),
            blurRadius = 5f
        )
    )



    fun convertUnits(){
        // ?: - elvis operator
        val inputValueDouble = inputValue.toDoubleOrNull() ?: 0.0
        val result = (inputValueDouble * conversionFactor.doubleValue * 100  / oConversionFactor.doubleValue)/100.0
        val roundedResult = String.format("%.4f", result).toDouble()
        outputValue = roundedResult.toString()

    }

    Column(
        modifier = Modifier.fillMaxSize(),
        verticalArrangement = Arrangement.Top,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        //b here all the UI elements will stacked below each other
        Text(
            text = "Unit Converter",
            style = customTextStyle,
            modifier = Modifier.padding(16.dp))
        Spacer(modifier= Modifier.height(16.dp))
        OutlinedTextField(
            value = inputValue,
            onValueChange = {
                inputValue = it
                // Check if the input contains only digits
                if (!it.all { char -> char.isDigit() }) {
                    // Show Toast message for invalid input (non-numeric)
                    Toast.makeText(context, "Enter Numeric Value", Toast.LENGTH_SHORT).show()
                } else {
                    // Call convertUnits() or any other function if it's numeric
                    convertUnits()
                }
            //here gpes what should happen, when thw value of our OutLinedTextField changes
            },
            label = {Text("Enter Value")})
        Spacer(modifier= Modifier.height(16.dp))
        Row {
           //Input Box
            Box{
                //Input Button
                Button(onClick = { iExpanded = true })
                {
                    Text(text = inputUnit)
                    Icon(Icons.Default.ArrowDropDown,
                        contentDescription ="Arrow Down")
                }
                DropdownMenu(expanded = iExpanded, onDismissRequest = { iExpanded = false })
                {
                    DropdownMenuItem(
                        text = {Text("Millimeters") },
                        onClick = {
                            iExpanded= false
                            inputUnit= "Millimeters"
                            conversionFactor.doubleValue =0.001
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = {Text("Centimeters") },
                        onClick = {
                            iExpanded= false
                            inputUnit= "Centimeters"
                            conversionFactor.doubleValue = 0.01
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = {Text("Meters") },
                        onClick = {
                            iExpanded= false
                            inputUnit= "Meters"
                            conversionFactor.doubleValue = 1.0
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = {Text("Kilometers") },
                        onClick = {
                            iExpanded= false
                            inputUnit= "Kilometers"
                            conversionFactor.doubleValue = 1000.0
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = {Text("Feet") },
                        onClick = {
                            iExpanded= false
                            inputUnit= "Feet"
                            conversionFactor.doubleValue = 0.3048
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = {Text("Inch") },
                        onClick = {
                            iExpanded= false
                            inputUnit= "Inch"
                            conversionFactor.doubleValue = 0.0254
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = {Text("Yard") },
                        onClick = {
                            iExpanded= false
                            inputUnit= "Yard"
                            conversionFactor.doubleValue = 0.9144
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = {Text("Miles") },
                        onClick = {
                            iExpanded= false
                            inputUnit= "Miles"
                            conversionFactor.doubleValue = 1609.344
                            convertUnits()
                        }
                    )

                }
            }
            Spacer(modifier = Modifier.width(16.dp))
            //Output Box
            Box{
                //Output Button
                Button(onClick = { oExpanded = true })
                {
                    Text(text = outputUnit)
                    Icon(Icons.Default.ArrowDropDown,
                        contentDescription ="Arrow Down")
                }
                DropdownMenu(expanded = oExpanded, onDismissRequest = { oExpanded= false })
                {
                    DropdownMenuItem(text = {Text("Millimeters") },
                        onClick = {
                            oExpanded= false
                            outputUnit = "Millimeters"
                            oConversionFactor.doubleValue = 0.001
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = {Text("Centimeters") },
                        onClick = {
                            oExpanded= false
                            outputUnit = "Centimeters"
                            oConversionFactor.doubleValue = 0.01
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = {Text("Meters") },
                        onClick = {
                            oExpanded= false
                            outputUnit = "Meters"
                            oConversionFactor.doubleValue = 1.00
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = {Text("Kilometers") },
                        onClick = {
                            oExpanded= false
                            outputUnit= "Kilometers"
                            oConversionFactor.doubleValue = 1000.0
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = {Text("Feet") },
                        onClick = {
                            oExpanded= false
                            outputUnit= "Feet"
                            oConversionFactor.doubleValue = 0.3048
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = {Text("Inch") },
                        onClick = {
                            oExpanded= false
                            outputUnit= "Inch"
                            oConversionFactor.doubleValue = 0.0254
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = {Text("Yard") },
                        onClick = {
                            oExpanded= false
                            outputUnit= "Yard"
                            oConversionFactor.doubleValue = 0.9144
                            convertUnits()
                        }
                    )
                    DropdownMenuItem(
                        text = {Text("Miles") },
                        onClick = {
                            oExpanded= false
                            outputUnit= "Miles"
                            oConversionFactor.doubleValue = 1609.344
                            convertUnits()
                        }
                    )
                }
            }
            //b here all the UI elements will stacked next to each other
        }
        Spacer(modifier= Modifier.height(16.dp))
        //Result Text
        Text(
            text = "Result: $outputValue $outputUnit",
            style = TextStyle(
                fontSize = 30.sp,                 // Larger font size for emphasis
                fontWeight = FontWeight.Bold,      // Makes the text bold
                color = Color(0xFF4CAF50),         // Stylish green color
                fontFamily = FontFamily.Serif,     // Elegant serif font
                letterSpacing = 1.5.sp,            // Increases letter spacing for readability
                lineHeight = 36.sp,                // Better spacing between lines
                textAlign = TextAlign.Center,      // Centers the text
                shadow = Shadow(                   // Adds a soft shadow effect
                    color = Color.Gray,
                    offset = Offset(4f, 4f),
                    blurRadius = 6f
                )
            ),
            modifier = Modifier.padding(16.dp)    // Adds padding around the text
        )
    }
}

@Preview(showBackground = true)
@Composable
fun UnitConverterPreview() {
    UnitConverter()
}

