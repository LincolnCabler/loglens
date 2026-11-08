namespace HelloLogLens;

/// <summary>Counts log lines by level. Expected line format: "2026-11-08T10:00:00Z INFO message".</summary>
public static class LogSummarizer
{
    public static readonly string[] Levels = ["INFO", "WARN", "ERROR"];

    public static Dictionary<string, int> CountByLevel(IEnumerable<string> lines)
    {
        var counts = Levels.ToDictionary(level => level, _ => 0);

        foreach (var line in lines)
        {
            var parts = line.Split(' ', 3, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length < 2)
            {
                continue; // blank or malformed line
            }

            var level = parts[1].ToUpperInvariant();
            if (counts.ContainsKey(level))
            {
                counts[level]++;
            }
        }

        return counts;
    }
}
