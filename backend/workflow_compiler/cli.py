from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from workflow_compiler.env import gemini_model, load_env_files
from workflow_compiler.gemini_video import extract_workflows_from_video, extraction_to_dict
from workflow_compiler.ir import WorkflowExtraction


def main(argv: list[str] | None = None) -> int:
    load_env_files()
    parser = argparse.ArgumentParser(
        prog="compile-workflow",
        description="Phase 1: turn screen recordings into structured workflows.",
    )
    sub = parser.add_subparsers(dest="command", required=True)

    from_video = sub.add_parser(
        "from-video",
        help="Send one or more videos to Gemini and write workflow JSON.",
    )
    from_video.add_argument(
        "--video",
        action="append",
        dest="videos",
        required=True,
        help="Local video path or YouTube URL. Repeat for multiple clips.",
    )
    from_video.add_argument(
        "--out",
        required=True,
        help="Output .json file, or a directory if you pass multiple --video values.",
    )
    from_video.add_argument(
        "--model",
        default=None,
        help="Gemini model id. Defaults to GEMINI_MODEL or gemini-2.5-flash.",
    )
    from_video.add_argument(
        "--print-schema",
        action="store_true",
        help="Print the workflow JSON schema and exit (does not call Gemini).",
    )

    schema = sub.add_parser("schema", help="Print the workflow JSON schema.")
    schema.set_defaults(command="schema")

    args = parser.parse_args(argv)

    if args.command == "schema" or getattr(args, "print_schema", False):
        print(json.dumps(WorkflowExtraction.model_json_schema(), indent=2))
        return 0

    if args.command == "from-video":
        try:
            return _cmd_from_video(args)
        except (RuntimeError, FileNotFoundError, TimeoutError) as exc:
            print(exc, file=sys.stderr)
            return 1

    parser.error(f"Unknown command {args.command}")
    return 2


def _cmd_from_video(args: argparse.Namespace) -> int:
    model = args.model or gemini_model()
    videos: list[str] = args.videos
    out = Path(args.out)

    if len(videos) > 1:
        if out.suffix.lower() == ".json":
            print(
                "When passing multiple --video values, --out must be a directory.",
                file=sys.stderr,
            )
            return 2
        out.mkdir(parents=True, exist_ok=True)
        written: list[Path] = []
        for video in videos:
            payload = _run_one(video, model)
            dest = out / f"{_stem(video)}.workflows.json"
            _write_json(dest, payload)
            written.append(dest)
            _summarize(payload, dest)
        print(f"Wrote {len(written)} files under {out}", file=sys.stderr)
        return 0

    payload = _run_one(videos[0], model)
    if out.suffix.lower() != ".json":
        out.mkdir(parents=True, exist_ok=True)
        dest = out / f"{_stem(videos[0])}.workflows.json"
    else:
        dest = out
    _write_json(dest, payload)
    _summarize(payload, dest)
    return 0


def _run_one(video: str, model: str) -> dict:
    print(f"Extracting workflows from {video} with {model}...", file=sys.stderr)
    extraction = extract_workflows_from_video(video, model=model)
    display = video if video.startswith("http") else str(Path(video).expanduser().resolve())
    return extraction_to_dict(extraction, video=display, model=model)


def _write_json(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")


def _stem(video: str) -> str:
    if video.startswith("http"):
        return "youtube"
    return Path(video).stem


def _summarize(payload: dict, dest: Path) -> None:
    workflows = payload.get("workflows") or []
    print(f"Wrote {dest} ({len(workflows)} workflow(s))", file=sys.stderr)
    for item in workflows:
        name = item.get("workflow_name", "(unnamed)")
        steps = len(item.get("steps") or [])
        print(f"  - {name} [{steps} steps]", file=sys.stderr)


if __name__ == "__main__":
    raise SystemExit(main())
