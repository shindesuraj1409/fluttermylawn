import 'package:contentful_rich_text/types/blocks.dart';
import 'package:contentful_rich_text/types/inlines.dart';
import 'package:contentful_rich_text/types/marks.dart';
import 'package:contentful_rich_text/types/types.dart';
import 'package:contentful_rich_text/widgets/hr.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/screens/profile/subscription/widgets/contentful_faq_paragraph.dart';
import 'package:my_lawn/screens/tips/widgets/contentful_specific/contentful_head.dart';
import 'package:my_lawn/screens/tips/widgets/contentful_specific/contentful_list_item.dart';
import 'package:my_lawn/screens/tips/widgets/contentful_specific/contentful_ordered_list.dart';
import 'package:my_lawn/screens/tips/widgets/contentful_specific/contentful_unordered_list.dart';

import 'contentful_faq_hyperlink.dart';

Options contentfulSubscriptionOptions(BuildContext context) => Options(
      renderMark: MARKS.defaultMarkRenderers = RenderMark({
        MARKS.BOLD.value: TextStyle(fontWeight: FontWeight.bold),
        MARKS.ITALIC.value: TextStyle(fontStyle: FontStyle.italic),
        MARKS.UNDERLINE.value: TextStyle(decoration: TextDecoration.underline),
      }),
      renderNode: RenderNode(
        {
          BLOCKS.PARAGRAPH.value: (node, next) => FaqParagraph(node, next),
          BLOCKS.HEADING_1.value: (node, next) => Heading(
                level: BLOCKS.HEADING_1,
                text: node['value'],
                textStyle: Theme.of(context).textTheme.headline1,
                content: node['content'],
                next: next,
              ),
          BLOCKS.HEADING_2.value: (node, next) => Heading(
                level: BLOCKS.HEADING_2,
                text: node['value'],
                content: node['content'],
                textStyle: Theme.of(context).textTheme.headline2,
                next: next,
              ),
          BLOCKS.HEADING_3.value: (node, next) => Heading(
                level: BLOCKS.HEADING_3,
                text: node['value'],
                content: node['content'],
                textStyle: Theme.of(context).textTheme.headline3,
                next: next,
              ),
          BLOCKS.HEADING_4.value: (node, next) => Heading(
                level: BLOCKS.HEADING_4,
                text: node['value'],
                content: node['content'],
                textStyle: Theme.of(context).textTheme.headline4,
                next: next,
              ),
          BLOCKS.HEADING_5.value: (node, next) => Heading(
                level: BLOCKS.HEADING_5,
                text: node['value'],
                content: node['content'],
                textStyle: Theme.of(context).textTheme.headline5,
                next: next,
              ),
          BLOCKS.HEADING_6.value: (node, next) => Heading(
                level: BLOCKS.HEADING_6,
                text: node['value'],
                content: node['content'],
                textStyle: Theme.of(context).textTheme.headline6,
                next: next,
              ),
          BLOCKS.EMBEDDED_ENTRY.value: (node, next) => Container(),
          BLOCKS.UL_LIST.value: (node, next) =>
              UnorderedList(node['content'], next),
          BLOCKS.OL_LIST.value: (node, next) =>
              OrderedList(node['content'], next),
          BLOCKS.LIST_ITEM.value: (node, next) => ListItem(
                text: node.value,
                type: node.nodeType == BLOCKS.OL_LIST.value
                    ? LI_TYPE.ORDERED
                    : LI_TYPE.UNORDERED,
                children: node['content'],
              ),
          BLOCKS.QUOTE.value: (node, next) => Container(),
          BLOCKS.HR.value: (node, next) => Hr(),
          INLINES.ASSET_HYPERLINK.value: (node, next) =>
              _defaultInline(INLINES.ASSET_HYPERLINK, node as Inline),
          INLINES.ENTRY_HYPERLINK.value: (node, next) =>
              _defaultInline(INLINES.ENTRY_HYPERLINK, node as Inline),
          INLINES.EMBEDDED_ENTRY.value: (node, next) =>
              _defaultInline(INLINES.EMBEDDED_ENTRY, node as Inline),
          INLINES.HYPERLINK.value: (node, next) {
            return FaqHyperlink(node, next, context);
          },
        },
      ),
    );
Widget _defaultInline(INLINES type, Inline node) => Container();
