package com.izinplanla.app.widget

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import com.izinplanla.app.R
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Home screen widget showing the remaining leave balance and the next holiday.
 *
 * Draft from task 05 so the manifest entry compiles. Task 14 implements the
 * real content from [widgetData] written by HomeWidgetService.
 */
class LeaveWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.leave_widget)
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}
