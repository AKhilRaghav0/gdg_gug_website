import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownEditor extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final String? hintText;
  final double height;
  final bool showPreview;

  const MarkdownEditor({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.hintText = 'Start writing...',
    this.height = 400,
    this.showPreview = true,
  });

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor>
    with TickerProviderStateMixin {
  late TextEditingController _controller;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _tabController = TabController(length: 2, vsync: this);
    
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _insertText(String text, {bool wrapSelection = false}) {
    final selection = _controller.selection;
    final currentText = _controller.text;
    
    if (wrapSelection && selection.start != selection.end) {
      // Wrap selected text
      final selectedText = currentText.substring(selection.start, selection.end);
      final newText = text.replaceAll('|', selectedText);
      _controller.text = currentText.replaceRange(selection.start, selection.end, newText);
      _controller.selection = TextSelection.collapsed(
        offset: selection.start + newText.length,
      );
    } else {
      // Insert at cursor
      final cursorPos = selection.start;
      final newText = currentText.substring(0, cursorPos) + 
                     text + 
                     currentText.substring(cursorPos);
      _controller.text = newText;
      _controller.selection = TextSelection.collapsed(
        offset: cursorPos + text.length,
      );
    }
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _ToolbarButton(
            icon: Icons.format_bold,
            tooltip: 'Bold',
            onPressed: () => _insertText('**|**', wrapSelection: true),
          ),
          _ToolbarButton(
            icon: Icons.format_italic,
            tooltip: 'Italic',
            onPressed: () => _insertText('*|*', wrapSelection: true),
          ),
          _ToolbarButton(
            icon: Icons.title,
            tooltip: 'Heading 1',
            onPressed: () => _insertText('# '),
          ),
          _ToolbarButton(
            icon: Icons.title,
            tooltip: 'Heading 2',
            onPressed: () => _insertText('## '),
          ),
          _ToolbarButton(
            icon: Icons.format_list_bulleted,
            tooltip: 'Bullet List',
            onPressed: () => _insertText('- '),
          ),
          _ToolbarButton(
            icon: Icons.format_list_numbered,
            tooltip: 'Numbered List',
            onPressed: () => _insertText('1. '),
          ),
          _ToolbarButton(
            icon: Icons.code,
            tooltip: 'Code Block',
            onPressed: () => _insertText('```\n|\n```'),
          ),
          _ToolbarButton(
            icon: Icons.link,
            tooltip: 'Link',
            onPressed: () => _insertText('[|](url)'),
          ),
          _ToolbarButton(
            icon: Icons.image,
            tooltip: 'Image',
            onPressed: () => _insertText('![alt text](image-url)'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditor() {
    return Container(
      height: widget.height,
      child: widget.showPreview 
        ? Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Edit'),
                  Tab(text: 'Preview'),
                ],
                labelColor: Colors.blue[700],
                unselectedLabelColor: Colors.grey[600],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTextEditor(),
                    _buildPreview(),
                  ],
                ),
              ),
            ],
          )
        : _buildTextEditor(),
    );
  }

  Widget _buildTextEditor() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
          height: 1.5,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Markdown(
        data: _controller.text.isEmpty ? '*Nothing to preview*' : _controller.text,
        selectable: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildToolbar(),
        _buildEditor(),
      ],
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 18,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
