using HelloLogLens;

namespace HelloLogLens.Tests;

public class LogSummarizerTests
{
    // Same seven lines as samples/HelloLogLens/sample-log.txt.
    private static readonly string[] SampleLines =
    [
        "2026-11-08T10:00:00Z INFO Service started",
        "2026-11-08T10:00:05Z INFO Listening on port 8080",
        "2026-11-08T10:01:12Z WARN Slow query took 1450 ms",
        "2026-11-08T10:02:30Z INFO Request handled in 42 ms",
        "2026-11-08T10:03:47Z ERROR Database connection timed out",
        "2026-11-08T10:03:48Z WARN Retrying database connection (attempt 1)",
        "2026-11-08T10:03:50Z INFO Database connection restored",
    ];

    [Fact]
    public void CountByLevel_SampleLines_CountsEachLevel()
    {
        var counts = LogSummarizer.CountByLevel(SampleLines);

        Assert.Equal(4, counts["INFO"]);
        Assert.Equal(2, counts["WARN"]);
        Assert.Equal(1, counts["ERROR"]);
    }

    [Fact]
    public void CountByLevel_LevelIsLowercase_IsStillCounted()
    {
        var counts = LogSummarizer.CountByLevel(["2026-11-08T10:00:00Z warn Disk at 85%"]);

        Assert.Equal(1, counts["WARN"]);
    }

    [Theory]
    [InlineData("")]
    [InlineData("2026-11-08T10:00:00Z")]
    [InlineData("2026-11-08T10:00:00Z DEBUG Not a tracked level")]
    public void CountByLevel_BlankMalformedOrUnknown_CountsNothing(string line)
    {
        var counts = LogSummarizer.CountByLevel([line]);

        Assert.All(counts.Values, count => Assert.Equal(0, count));
    }
}
