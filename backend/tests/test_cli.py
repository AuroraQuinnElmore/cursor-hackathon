from workflow_compiler.cli import main


def test_help_exits_zero() -> None:
    try:
        main(["--help"])
    except SystemExit as exc:
        assert exc.code == 0
    else:
        raise AssertionError("argparse help should SystemExit 0")


def test_schema_prints_json(capsys) -> None:
    code = main(["schema"])
    assert code == 0
    out = capsys.readouterr().out
    assert "workflows" in out
    assert "workflow_name" in out
