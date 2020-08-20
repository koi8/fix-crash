using System;

namespace crash
{
    class Program
    {
        static void Main(string[] args)
        {
            System.IO.File.ReadLines("c:\\notes.txt");
        }
    }
}