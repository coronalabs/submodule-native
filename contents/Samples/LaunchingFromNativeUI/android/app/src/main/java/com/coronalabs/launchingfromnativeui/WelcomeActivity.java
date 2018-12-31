package com.coronalabs.launchingfromnativeui;

/**
 * This is the launcher activity for this sample application.
 * It displays buttons used to show a Corona activity via an Android intent.
 * The intent's extras are passed to the Corona activity's "main.lua" file via Lua's launch arguments
 * which tells the Lua script which scene to load.
 */
public class WelcomeActivity extends android.app.Activity {
	/**
	 * Called when the activity has been created.
	 * @param savedInstanceState The bundle containing arguments used to initialize this activity.
	 */
    @Override
	protected void onCreate(android.os.Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
		
		android.widget.FrameLayout.LayoutParams layoutParams;

		// Create the ViewGroup that will contain all UI elements in this activity.
		android.widget.FrameLayout viewGroup = new android.widget.FrameLayout(this);
		setContentView(viewGroup);
		
		// Add a large Corona background image.
		android.widget.ImageView coronaImage = new android.widget.ImageView(this);
		coronaImage.setBackgroundColor(android.graphics.Color.TRANSPARENT);
		coronaImage.setImageResource(R.drawable.welcome_background);
		layoutParams = new android.widget.FrameLayout.LayoutParams(
							   android.widget.FrameLayout.LayoutParams.MATCH_PARENT,
							   android.widget.FrameLayout.LayoutParams.MATCH_PARENT,
							   android.view.Gravity.CENTER_HORIZONTAL | android.view.Gravity.CENTER_VERTICAL);
		viewGroup.addView(coronaImage, layoutParams);
		
		// Create a button group aligned to the bottom of the screen.
		android.widget.LinearLayout buttonGroup = new android.widget.LinearLayout(this);
		layoutParams = new android.widget.FrameLayout.LayoutParams(
							   android.widget.FrameLayout.LayoutParams.MATCH_PARENT,
							   android.widget.FrameLayout.LayoutParams.WRAP_CONTENT,
							   android.view.Gravity.CENTER_HORIZONTAL | android.view.Gravity.BOTTOM);
		buttonGroup.setPadding(8, 8, 8, 8);
		buttonGroup.setGravity(android.view.Gravity.CENTER);
		buttonGroup.setOrientation(android.widget.LinearLayout.VERTICAL);
		viewGroup.addView(buttonGroup, layoutParams);

		// Add Start button to screen used to display the CoronaActivity.

		// Set up a button used to launch a Corona activity displaying the "default" scene.
		// Note: In this case, no intent extras are added.
		android.widget.Button showDefaultButton = new android.widget.Button(this);
		showDefaultButton.setText(R.string.show_default_screen);
		buttonGroup.addView(showDefaultButton);
		showDefaultButton.setOnClickListener(new android.view.View.OnClickListener() {
			public void onClick(android.view.View view) {
				com.ansca.corona.CoronaEnvironment.showCoronaActivity(view.getContext());
			}
		});

		// Set up a button used to launch a Corona activity displaying the "polygon" scene.
		android.widget.Button showPolygonsButton = new android.widget.Button(this);
		showPolygonsButton.setText(R.string.show_polygons_screen);
		buttonGroup.addView(showPolygonsButton);
		showPolygonsButton.setOnClickListener(new android.view.View.OnClickListener() {
			public void onClick(android.view.View view) {
				Class coronaActivityClass = com.ansca.corona.CoronaActivity.class;
				android.content.Intent intent = new android.content.Intent(view.getContext(), coronaActivityClass);
				intent.addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK);
				intent.addFlags(android.content.Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
				intent.putExtra("sceneName", "polygons");
				view.getContext().startActivity(intent);
			}
		});

		// Set up a button used to launch a Corona activity displaying the "fishies" scene.
		android.widget.Button showFishiesButton = new android.widget.Button(this);
		showFishiesButton.setText(R.string.show_fishies_screen);
		buttonGroup.addView(showFishiesButton);
		showFishiesButton.setOnClickListener(new android.view.View.OnClickListener() {
			public void onClick(android.view.View view) {
				Class coronaActivityClass = com.ansca.corona.CoronaActivity.class;
				android.content.Intent intent = new android.content.Intent(view.getContext(), coronaActivityClass);
				intent.addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK);
				intent.addFlags(android.content.Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
				intent.putExtra("sceneName", "fishies");
				view.getContext().startActivity(intent);
			}
		});

		// Set up a button used to launch a Corona activity displaying the "clock" scene.
		android.widget.Button showClockButton = new android.widget.Button(this);
		showClockButton.setText(R.string.show_clock_screen);
		buttonGroup.addView(showClockButton);
		showClockButton.setOnClickListener(new android.view.View.OnClickListener() {
			public void onClick(android.view.View view) {
				Class coronaActivityClass = com.ansca.corona.CoronaActivity.class;
				android.content.Intent intent = new android.content.Intent(view.getContext(), coronaActivityClass);
				intent.addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK);
				intent.addFlags(android.content.Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
				intent.putExtra("sceneName", "clock");
				view.getContext().startActivity(intent);
			}
		});
    }
}
