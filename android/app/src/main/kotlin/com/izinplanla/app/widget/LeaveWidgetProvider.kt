package com.izinplanla.app.widget

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.res.Configuration
import android.graphics.Typeface
import android.graphics.drawable.Icon
import android.os.Build
import android.text.SpannableStringBuilder
import android.text.Spanned
import android.text.style.ForegroundColorSpan
import android.text.style.RelativeSizeSpan
import android.text.style.StyleSpan
import android.widget.RemoteViews
import com.izinplanla.app.MainActivity
import com.izinplanla.app.R
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.util.Calendar
import java.util.Locale
import org.json.JSONException
import org.json.JSONObject

/**
 * Home screen widget showing the remaining leave balance and the next holiday.
 *
 * Dart (`DefaultHomeWidgetService`) stores finished texts for each of the
 * coming days under [DATA_KEY]. This provider only picks the entry of the
 * device's current date and draws it, so no user-visible text lives here.
 * An inexact alarm redraws the widget after midnight, so the holiday
 * countdown moves on without the app running.
 */
class LeaveWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val content = readContent(widgetData)
        for (id in appWidgetIds) {
            appWidgetManager.updateAppWidget(id, buildViews(context, content))
        }
        scheduleDayChange(context)
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        context.getSystemService(AlarmManager::class.java)?.cancel(dayChangeIntent(context))
    }

    private class Entry(
        val value: String,
        val caption: String,
        val holiday: String,
        val description: String,
    )

    private class Content(val theme: String, val entry: Entry?)

    private fun readContent(widgetData: SharedPreferences): Content? {
        val raw = widgetData.getString(DATA_KEY, null) ?: return null
        val root =
            try {
                JSONObject(raw)
            } catch (error: JSONException) {
                return null
            }
        val today = root.optJSONObject("days")?.optJSONObject(todayKey())
        return Content(
            theme = root.optString("theme", THEME_SYSTEM),
            entry = readEntry(today) ?: readEntry(root.optJSONObject("fallback")),
        )
    }

    private fun readEntry(json: JSONObject?): Entry? {
        if (json == null) return null
        return Entry(
            value = json.optString("value"),
            caption = json.optString("caption"),
            holiday = json.optString("holiday"),
            description = json.optString("description"),
        )
    }

    private fun buildViews(context: Context, content: Content?): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.leave_widget)
        applyBackground(context, views, content?.theme ?: THEME_SYSTEM)
        // Without data the layout keeps its defaults: the widget description
        // until the app has run once.
        content?.entry?.let { entry ->
            views.setTextViewText(R.id.widget_text, styledText(entry))
            views.setContentDescription(R.id.widget_root, entry.description)
        }
        views.setOnClickPendingIntent(
            R.id.widget_root,
            HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
        )
        return views
    }

    /**
     * The hero gradient of the app. An explicit app theme wins, otherwise
     * the launcher's night mode decides. From Android 12 the launcher
     * switches the image itself when the system theme changes.
     */
    private fun applyBackground(context: Context, views: RemoteViews, theme: String) {
        val light = R.drawable.widget_background_light
        val dark = R.drawable.widget_background_dark
        when {
            theme == THEME_LIGHT -> views.setImageViewResource(R.id.widget_background, light)
            theme == THEME_DARK -> views.setImageViewResource(R.id.widget_background, dark)
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.S ->
                views.setIcon(
                    R.id.widget_background,
                    "setImageIcon",
                    Icon.createWithResource(context, light),
                    Icon.createWithResource(context, dark),
                )
            else -> {
                val nightMask = context.resources.configuration.uiMode and
                    Configuration.UI_MODE_NIGHT_MASK
                val night = nightMask == Configuration.UI_MODE_NIGHT_YES
                views.setImageViewResource(R.id.widget_background, if (night) dark else light)
            }
        }
    }

    /**
     * One text view, so the auto-size of the layout shrinks all lines
     * together when a large system font does not fit, instead of cutting
     * one of them.
     */
    private fun styledText(entry: Entry): CharSequence {
        val text = SpannableStringBuilder()
        if (entry.value.isNotEmpty()) {
            append(text, entry.value, RelativeSizeSpan(NUMBER_SCALE), StyleSpan(Typeface.BOLD))
            text.append('\n')
        }
        text.append(entry.caption)
        if (entry.holiday.isNotEmpty()) {
            text.append('\n')
            // A half-height empty line between the balance and the holiday.
            append(text, "\n", RelativeSizeSpan(GAP_SCALE))
            append(text, entry.holiday, ForegroundColorSpan(MUTED_TEXT))
        }
        return text
    }

    private fun append(text: SpannableStringBuilder, part: String, vararg spans: Any) {
        val start = text.length
        text.append(part)
        for (span in spans) {
            text.setSpan(span, start, text.length, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)
        }
    }

    /** Inexact and non-waking: runs the first time the device is awake after midnight. */
    private fun scheduleDayChange(context: Context) {
        val alarmManager = context.getSystemService(AlarmManager::class.java) ?: return
        val nextDay =
            Calendar.getInstance().apply {
                add(Calendar.DAY_OF_YEAR, 1)
                set(Calendar.HOUR_OF_DAY, 0)
                set(Calendar.MINUTE, 0)
                set(Calendar.SECOND, 5)
                set(Calendar.MILLISECOND, 0)
            }
        alarmManager.set(AlarmManager.RTC, nextDay.timeInMillis, dayChangeIntent(context))
    }

    private fun dayChangeIntent(context: Context): PendingIntent {
        val ids =
            AppWidgetManager.getInstance(context)
                .getAppWidgetIds(ComponentName(context, LeaveWidgetProvider::class.java))
        val intent =
            Intent(context, LeaveWidgetProvider::class.java)
                .setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE)
                .putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
        return PendingIntent.getBroadcast(
            context,
            DAY_CHANGE_REQUEST,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    /** Local date as `yyyy-MM-dd`, the key format of the Dart side. */
    private fun todayKey(): String {
        val now = Calendar.getInstance()
        return String.format(
            Locale.ROOT,
            "%04d-%02d-%02d",
            now.get(Calendar.YEAR),
            now.get(Calendar.MONTH) + 1,
            now.get(Calendar.DAY_OF_MONTH),
        )
    }

    private companion object {
        /** Keep in sync with `HomeWidgetContent.storageKey` in Dart. */
        const val DATA_KEY = "leave_widget_data"

        const val THEME_SYSTEM = "system"
        const val THEME_LIGHT = "light"
        const val THEME_DARK = "dark"

        const val DAY_CHANGE_REQUEST = 1407

        /** The large number, relative to the body text. */
        const val NUMBER_SCALE = 2.4f

        const val GAP_SCALE = 0.5f

        /**
         * `AppPalette.blue91`, the muted text of the hero card. Over
         * 5:1 on every colour of both gradients.
         */
        val MUTED_TEXT: Int = 0xFFDDE4FF.toInt()
    }
}
