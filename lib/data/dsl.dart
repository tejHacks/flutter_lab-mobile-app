// Tiny helpers that keep lesson content short and readable.
// Inline formatting supported in text: `code` and **bold**.
import '../models/lesson.dart';

Section p(String text) => TextSection(text);
Section h(String text) => HeadingSection(text);
Section code(String src, {String? caption, String? run}) =>
    CodeSection(src.trim(), caption: caption, runKey: run);
Section sh(String src, {String? caption}) =>
    CodeSection(src.trim(), caption: caption, isShell: true);
Section tip(String text) => CalloutSection(CalloutKind.tip, text);
Section note(String text) => CalloutSection(CalloutKind.note, text);
Section warn(String text) => CalloutSection(CalloutKind.warning, text);
Section analogy(String text) => CalloutSection(CalloutKind.analogy, text);
Section bullets(List<String> items) => BulletsSection(items);
Section steps(List<String> items) => BulletsSection(items, numbered: true);
Section demo(String key, {String? caption}) => DemoSection(key, caption: caption);

QuizQuestion q(String question, List<String> options, int answer, String why) =>
    QuizQuestion(question, options, answer, why);
