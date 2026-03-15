package com.qnote.qnote

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews

class QnoteWidgetSmall : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.qnote_widget_small)
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

            val title = prefs.getString("memo_0_title", "No memos") ?: "No memos"
            views.setTextViewText(R.id.memo_0_title, title)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

class QnoteWidgetMedium : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.qnote_widget_medium)
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

            for (i in 0..1) {
                val titleId = context.resources.getIdentifier("memo_${i}_title", "id", context.packageName)
                val bodyId = context.resources.getIdentifier("memo_${i}_body", "id", context.packageName)
                val title = prefs.getString("memo_${i}_title", "") ?: ""
                val body = prefs.getString("memo_${i}_body", "") ?: ""
                views.setTextViewText(titleId, title)
                views.setTextViewText(bodyId, body)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}

class QnoteWidgetLarge : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.qnote_widget_large)
            val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)

            for (i in 0..3) {
                val titleId = context.resources.getIdentifier("memo_${i}_title", "id", context.packageName)
                val bodyId = context.resources.getIdentifier("memo_${i}_body", "id", context.packageName)
                val title = prefs.getString("memo_${i}_title", "") ?: ""
                val body = prefs.getString("memo_${i}_body", "") ?: ""
                views.setTextViewText(titleId, title)
                views.setTextViewText(bodyId, body)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
