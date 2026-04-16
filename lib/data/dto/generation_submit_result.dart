class GenerationSubmitResult {
  const GenerationSubmitResult({
    this.taskId,
    this.imageUrls = const <String>[],
  });

  final String? taskId;
  final List<String> imageUrls;
}
